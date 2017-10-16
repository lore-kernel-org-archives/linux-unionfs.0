From: charles zheng <czheng2@nd.edu>
Subject: Re: [OVERLAYFS] Can I create file in directory on lower layer located
 on NFS
Date: Mon, 16 Oct 2017 18:10:25 -0400
Message-ID: <CAAeanMzpzsNVxCaOHp=0t=5dcQG7BcOUbogZ_t1T3cDTZTzQ1A@mail.gmail.com>
References: <CAAeanMz7d7UpoVj-yebH-66B-wF0kxT1vwJdQR73kKu=6TQdYA@mail.gmail.com>
 <CAOQ4uxhxU0PYe=aV2OR5UpU_fDTAWe6ex1m_oq0nCq8OGK-eJQ@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Return-path: <linux-unionfs-owner@vger.kernel.org>
Received: from mail-wm0-f67.google.com ([74.125.82.67]:48061 "EHLO
        mail-wm0-f67.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1754528AbdJPWK1 (ORCPT
        <rfc822;linux-unionfs@vger.kernel.org>);
        Mon, 16 Oct 2017 18:10:27 -0400
Received: by mail-wm0-f67.google.com with SMTP id t69so177433wmt.2
        for <linux-unionfs@vger.kernel.org>; Mon, 16 Oct 2017 15:10:27 -0700 (PDT)
In-Reply-To: <CAOQ4uxhxU0PYe=aV2OR5UpU_fDTAWe6ex1m_oq0nCq8OGK-eJQ@mail.gmail.com>
Sender: linux-unionfs-owner@vger.kernel.org
List-Id: linux-unionfs@vger.kernel.org
To: Amir Goldstein <amir73il@gmail.com>
Cc: Miklos Szeredi <miklos@szeredi.hu>, overlayfs <linux-unionfs@vger.kernel.org>, Lukas Rupprecht <Lukas.Rupprecht@ibm.com>, Vasily <vtarasov@us.ibm.com>, Douglas Thain <dthain@nd.edu>, Dean Hildebrand <seattleplus@gmail.com>, dimitrios.skourtis@ibm.com, mmohamed@us.ibm.com, aswarke@us.ibm.com

Hi Amir,

Thanks for the prompt reply. The Linux distribution is RHEL 7.4 and
the kernel version is
3.10.0-693.2.2.el7.x86_64

Following is the dmesg output

---------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
[ 1341.548099] TECH PREVIEW: Overlay filesystem may not be fully supported.
Please review provided documentation for limitations.
---------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------

Following is the log message from /proc/self/mountinfo

---------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
112 62 0:40 / /mnt/nfs rw,relatime shared:63 - nfs4
10.32.8.113:/var/nfs
rw,vers=4.1,rsize=524288,wsize=524288,namlen=255,hard,proto=tcp,port=0,timeo=600,retrans=2,sec=sys,clientaddr=10.32.8.113,local_lock=none,addr=10.32.8.113
113 62 0:39 / /home/czheng2/test/merged rw,relatime shared:65 -
overlay overlay
rw,lowerdir=/mnt/nfs/lower,upperdir=/home/czheng2/test/upper,workdir=/home/czheng2/test/work
---------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------

I also tried on Fedora 26 with kernel version
4.13.5-200.fc26.x86_64

I got same error, but this time, I cannot find overlay related log from dmesg

Following is the log message from /proc/self/mountinfo

---------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
202 66 0:54 / /mnt/nfs rw,relatime shared:145 - nfs4
192.168.10.123:/var/nfs
rw,vers=4.2,rsize=1048576,wsize=1048576,namlen=255,hard,proto=tcp,timeo=600,retrans=2,sec=sys,clientaddr=192.168.10.123,local_lock=none,addr=192.168.10.123
205 84 0:47 / /home/zc/test/merged rw,relatime shared:152 - overlay
overlay rw,seclabel,lowerdir=/mnt/nfs/lower,upperdir=/home/zc/test/upper,workdir=/home/zc/test/work
---------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------

Best,
Charles

On Mon, Oct 16, 2017 at 4:41 PM, Amir Goldstein <amir73il@gmail.com> wrote:
> On Mon, Oct 16, 2017 at 7:13 PM, charles zheng <czheng2@nd.edu> wrote:
>> Hi Miklos,
>>
>> We are developing a docker related system that requires to union
>> directories on NFS and local filesystem.  I successfully created a
>> overlayfs that has lower layer located on NFS and upper layer located
>> on the local file system. But when I tried to create new files in the
>> directory located on NFS, I got error message: "Operation not
>> supported". Does that mean I can not create new files inside the
>> directory located on NFS? But base on the documentation of overlayfs,
>> lower layer does not need to be writable.
>>
>> Steps to reproduce the problem are (/mnt/nfs is the NFS mount,
>> /home/zc is the local mount)
>>
>> 1. create directory "/mnt/nfs/lower/lower_dir"
>>
>> 2. create directories "/home/zc/upper/upper_dir", "/home/zc/work" and
>> "/home/zc/merged"
>>
>> 3. create overlayfs by running command
>>
>> mount -t overlay overlay -o\
>> lowerdir=/mnt/nfs/lower,\
>> upperdir=/home/zc/upper,\
>> workdir=/home/zc/work \
>> /home/zc/merged
>>
>> 4. Try to create new file "/merged/lower_dir/test.txt" and get error
>> message "Operation not supported"
>>
>
> Hi Charles,
>
> This should definitely work.
> Please specify with kernel version/commit you are testing with
> Please attach relevant overlayfs logs from dmesg when you get the
> error and from overlayfs mount time.
> Please attach content of /proc/self/mountinfo after overlay is mounted
>
> Thanks,
> Amir.
