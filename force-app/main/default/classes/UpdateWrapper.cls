public class UpdateWrapper {
    public list<String>fieldsList;
    public List<UpdateInfo> updates;
    public class UpdateInfo {
        public String table;
        public List<UpdateData> data;
    }
    public class UpdateData {
        public String Id;
        public String name;
        public String email;
    }
}