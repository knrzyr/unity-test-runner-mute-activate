import { promises as fsPromises } from 'fs';
import { join } from 'path';

const CreateServiceConfig = {
  async writeServiceConfig(workspace) {
    if (process.env.UNITY_LICENSE_SERVER === undefined)
      return false;
  
    const filePath = join(workspace, 'services-config.json');
  
    try {
      await fsPromises.writeFile(filePath, process.env.UNITY_LICENSE_SERVER, {
        flag: 'w',
      });
  
      return true;
  
    } catch (err) {
      console.log(err);
      return false;
    }
  }
}

export default CreateServiceConfig;