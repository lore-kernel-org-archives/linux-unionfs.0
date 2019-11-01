Return-Path: <jiangqi903@gmail.com>
Return-Path: <jiangqi903@gmail.com>
Subject: Re: Performance regression caused by stack operation of regular file
References: <ae928bd7-001a-061e-01f0-43b53a0adcd1@linux.alibaba.com>
From: Joseph Qi <jiangqi903@gmail.com>
Message-ID: <88f09a1e-2481-ac16-9754-77e21296b03a@gmail.com>
Date: Fri, 1 Nov 2019 15:27:45 +0800
MIME-Version: 1.0
In-Reply-To: <ae928bd7-001a-061e-01f0-43b53a0adcd1@linux.alibaba.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 8bit
To: JeffleXu <jefflexu@linux.alibaba.com>, miklos@szeredi.hu, Amir Goldstein <amir73il@gmail.com>
Cc: linux-unionfs@vger.kernel.org
List-ID: <linux-unionfs@vger.kernel.org>

Hi Miklos & Amir,
Could you please take a look at this?
It behaves different between the latest kernel and an old one, e.g. 4.9.

Thanks,
Joseph

On 19/10/28 14:21, JeffleXu wrote:
> Hi, Miklos,
> 
> I noticed a performance regression of reading/writing files in mergeddir caused by commit a6518f73e60e5044656d1ba587e7463479a9381a (vfs: don't open real), using unixbench fstime.
> 
> 
> Reproduce Steps:
> 
> 1. cd /mnt/lower/ && git clone https://github.com/kdlucas/byte-unixbench.git
> 
> 2. mount -t overlay overlay -olowerdir=/mnt/lower,upperdir=/mnt/upper,workdir=/mnt/work /mnt/merge
> 
> 3. cd /mnt/merge/byte-unixbench/UnixBench && ./Run -c 1 -i 1 fstime
> 
> 
> The score is 2870 before applying the patch, while it is 1780 after applying the patch, causing a 40% performance regression.
> 
> The testcase repeatedly reads 1024 bytes from one file and writes the readed data into another file, while both these two files
> 
> are created under /mnt/merge/tmp.  I have testsed the latest kernel 5.4.0-rc4+, same results.
> 
> 
> The perf shows that there's extra one call of file_remove_privs(), override_creds() and revert_creds() every write() syscall,
> 
> among which file_remove_privs() is pretty expensive.
> 
> 
> - perf data before applying the patch.
> 
> ```
> 
> -   53.00%     0.93%  fstime    [kernel.kallsyms]   [k] __vfs_write
>    - 52.08% __vfs_write
>       - 51.94% ext4_file_write_iter
>          + 48.89% __generic_file_write_iter
>            0.83% down_write_trylock
>            0.79% up_write
> 
> ```
> 
> 
> - perf data after applying the patch.
> 
> ```
> 
> +   94.88%     0.00%  fstime    [kernel.kallsyms]   [k] entry_SYSCALL_64_after_hwframe
> +   94.88%     4.67%  fstime    [kernel.kallsyms]   [k] do_syscall_64
> +   66.08%     1.60%  fstime    libc-2.17.so        [.] __GI___libc_write
> +   62.37%     0.23%  fstime    [kernel.kallsyms]   [k] ksys_write
> +   61.74%     0.62%  fstime    [kernel.kallsyms]   [k] vfs_write
> -   60.10%     0.49%  fstime    [kernel.kallsyms]   [k] __vfs_write
>    - 59.61% __vfs_write
>       - 59.56% ovl_write_iter
>          - 33.81% do_iter_write
>             - 32.50% do_iter_readv_writev
>                + ext4_file_write_iter
>          + 19.15% file_remove_privs
>            2.15% revert_creds
>            2.02% override_creds
>            0.64% down_write
>            0.63% up_write
> 
> ```
> 
> 
> Regards.
> 
> Jeffle
> 
