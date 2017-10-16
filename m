From: Amir Goldstein <amir73il@gmail.com>
Subject: Re: [OVERLAYFS] Can I create file in directory on lower layer located
 on NFS
Date: Mon, 16 Oct 2017 23:41:36 +0300
Message-ID: <CAOQ4uxhxU0PYe=aV2OR5UpU_fDTAWe6ex1m_oq0nCq8OGK-eJQ@mail.gmail.com>
References: <CAAeanMz7d7UpoVj-yebH-66B-wF0kxT1vwJdQR73kKu=6TQdYA@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Return-path: <linux-unionfs-owner@vger.kernel.org>
Received: from mail-qt0-f195.google.com ([209.85.216.195]:44295 "EHLO
        mail-qt0-f195.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1752358AbdJPUlh (ORCPT
        <rfc822;linux-unionfs@vger.kernel.org>);
        Mon, 16 Oct 2017 16:41:37 -0400
Received: by mail-qt0-f195.google.com with SMTP id 8so34520685qtv.1
        for <linux-unionfs@vger.kernel.org>; Mon, 16 Oct 2017 13:41:37 -0700 (PDT)
In-Reply-To: <CAAeanMz7d7UpoVj-yebH-66B-wF0kxT1vwJdQR73kKu=6TQdYA@mail.gmail.com>
Sender: linux-unionfs-owner@vger.kernel.org
List-Id: linux-unionfs@vger.kernel.org
To: charles zheng <czheng2@nd.edu>
Cc: Miklos Szeredi <miklos@szeredi.hu>, overlayfs <linux-unionfs@vger.kernel.org>, Lukas Rupprecht <Lukas.Rupprecht@ibm.com>, Vasily <vtarasov@us.ibm.com>, Douglas Thain <dthain@nd.edu>, Dean Hildebrand <seattleplus@gmail.com>, dimitrios.skourtis@ibm.com, mmohamed@us.ibm.com, aswarke@us.ibm.com

On Mon, Oct 16, 2017 at 7:13 PM, charles zheng <czheng2@nd.edu> wrote:
> Hi Miklos,
>
> We are developing a docker related system that requires to union
> directories on NFS and local filesystem.  I successfully created a
> overlayfs that has lower layer located on NFS and upper layer located
> on the local file system. But when I tried to create new files in the
> directory located on NFS, I got error message: "Operation not
> supported". Does that mean I can not create new files inside the
> directory located on NFS? But base on the documentation of overlayfs,
> lower layer does not need to be writable.
>
> Steps to reproduce the problem are (/mnt/nfs is the NFS mount,
> /home/zc is the local mount)
>
> 1. create directory "/mnt/nfs/lower/lower_dir"
>
> 2. create directories "/home/zc/upper/upper_dir", "/home/zc/work" and
> "/home/zc/merged"
>
> 3. create overlayfs by running command
>
> mount -t overlay overlay -o\
> lowerdir=/mnt/nfs/lower,\
> upperdir=/home/zc/upper,\
> workdir=/home/zc/work \
> /home/zc/merged
>
> 4. Try to create new file "/merged/lower_dir/test.txt" and get error
> message "Operation not supported"
>

Hi Charles,

This should definitely work.
Please specify with kernel version/commit you are testing with
Please attach relevant overlayfs logs from dmesg when you get the
error and from overlayfs mount time.
Please attach content of /proc/self/mountinfo after overlay is mounted

Thanks,
Amir.
