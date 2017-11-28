<%-- 
    Document   : newjsp
    Created on : 28/11/2017, 02:22:50 PM
    Author     : noe
--%>

<%@page import="java.io.*" %>
<%@page import="java.net.*" %>
<%@page import="java.util.HashMap"%>
       
        <%
        String content = "201122380";
        String printerIp = "192.168.0.25";
        int printerPort = 7654;

            Socket socket = new Socket(printerIp, printerPort);
            PrintWriter pwr  = new PrintWriter( new BufferedWriter( new OutputStreamWriter( socket.getOutputStream() )), true);
            BufferedReader br = new BufferedReader( new InputStreamReader( socket.getInputStream() ));
            DataOutputStream outt = new DataOutputStream(socket.getOutputStream());
            DataInputStream in;
        HashMap commands = new HashMap();
        String[] commandSequence = {"model", "size", "error", "store", "content", "print"};
        int contentLen = content.length();
        int resultLen = 0;
        byte[] command;
        command = new byte[]{(byte) 0x1d, (byte) 0x28, (byte) 0x6b, (byte) 0x04, (byte) 0x00, (byte) 0x31, (byte) 0x41, (byte) 0x32, (byte) 0x00};
        commands.put("model", command);
        resultLen += command.length;
        command = new byte[]{(byte) 0x1d, (byte) 0x28, (byte) 0x6b, (byte) 0x03, (byte) 0x00, (byte) 0x31, (byte) 0x43, (byte) 0x06};
        commands.put("size", command);
        resultLen += command.length;
        command = new byte[]{(byte) 0x1d, (byte) 0x28, (byte) 0x6b, (byte) 0x03, (byte) 0x00, (byte) 0x31, (byte) 0x45, (byte) 0x33};
        commands.put("error", command);
        resultLen += command.length;
        int storeLen = contentLen + 3;
        byte store_pL = (byte) (storeLen % 256);
        byte store_pH = (byte) (storeLen / 256);
        command = new byte[]{(byte) 0x1d, (byte) 0x28, (byte) 0x6b, store_pL, store_pH, (byte) 0x31, (byte) 0x50, (byte) 0x30};
        commands.put("store", command);
        resultLen += command.length;
        command = content.getBytes();
        commands.put("content", command);
        resultLen += command.length;
        command = new byte[]{(byte) 0x1d, (byte) 0x28, (byte) 0x6b, (byte) 0x03, (byte) 0x00, (byte) 0x31, (byte) 0x51, (byte) 0x30};
        commands.put("print", command);
        resultLen += command.length;
        int cnt = 0;
        int commandLen = 0;
        byte[] result = new byte[resultLen];
        for (String currCommand : commandSequence) {
            command = (byte[]) commands.get(currCommand);
            commandLen = command.length;
            System.arraycopy(command, 0, result, cnt, commandLen);
            cnt += commandLen;
        }
        byte[] byteArray = result;
           in = new DataInputStream(new ByteArrayInputStream(byteArray));
           while (in.available() != 0) {
                outt.write(in.readByte());
                outt.write(in.readByte());
            }
            pwr.println("hola");
            outt.write(0x00);
            outt.flush();
            outt.close();
            in.close();
            socket.close();
       %>
