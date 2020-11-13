import os
from azure.storage.blob import BlockBlobService, PublicAccess

##Prompt for the system name/host name of the image
system_name = input("System name and directory name in lowercase: ")

## Local file paths, set the root path and dir_name as the op name. The dir_name and container name must all be lowercase
root_path = "d:\\azure_loading"
dir_name = (system_name)

path = f"{root_path}\{dir_name}"
file_names = os.listdir(path)

# Create the BlockBlobService that is used to call the Blob service for the storage account - these envs need to be set in Windows first
account_name = os.environ.get('LAstorageaccount')
account_key = os.getenv('LAstorageaccountkey')

blob_service_client = BlockBlobService(
    account_name=account_name,
    account_key=account_key
)

# Create a container that the logic app knows to check in.
container_name = "plaso-import"
blob_service_client.create_container(container_name)

# Set the permission so the blobs are public.
blob_service_client.set_container_acl(
container_name, public_access=PublicAccess.Container)

print("Created container " + container_name)

##upload files to the container
for file_name in file_names:
    blob_name = f"{dir_name}-{file_name}"
    file_path = f"{path}\{file_name}"
    blob_service_client.create_blob_from_path(container_name, blob_name, file_path)
    print ("Uploading blob " + blob_name)