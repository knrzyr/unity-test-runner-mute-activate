import { promises as fsPromises } from 'fs';
import { join } from 'path';

const CreateServiceConfig = {
  async writeServiceConfig(licenseServer, workspace) {
    if (licenseServer.length <= 0)
      return false;
  
    const filePath = join(workspace, 'services-config.json');
  
    try {
      await fsPromises.writeFile(filePath, licenseServer, {
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