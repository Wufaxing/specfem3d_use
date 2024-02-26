# specfem3d_use
usage of sepcfem3d
step1编译:
(1)修改configure文件，6313行，SCOTCH_DIR="$srcdir/external_libs/scotch_5.1.12b"
(2)./configure FC=gfortran CC=gcc MPIFC=mpif90 MPI_INC=/usr/mpich/include --with-mpi MPI_LIB=/usr/mpich/lib --with-mpi --with-scotch-dir=/home/luyf/specfem3d-master/external_libs/scotch_5.1.12b
(3) make clean;make all
step2准备参数文件：
(1) 速度、密度模型
(2) 台站文件
(3) 修改FKMODEL文件（外部模型的文件）
(4) 修改Par_file文件
meshfem3D_files 文件夹下
(5) Mesh_Par_file文件
(6) interfaces.dat文件
step3:跑程序
./run_this_example.sh 即可，输出的文件都在OUTPUT_FILES文件夹内
