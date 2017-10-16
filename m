From: charles zheng <czheng2@nd.edu>
Subject: [OVERLAYFS] Can I create file in directory on lower layer located on NFS
Date: Mon, 16 Oct 2017 12:13:26 -0400
Message-ID: <CAAeanMz7d7UpoVj-yebH-66B-wF0kxT1vwJdQR73kKu=6TQdYA@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Return-path: <linux-unionfs-owner@vger.kernel.org>
Received: from mail-wm0-f65.google.com ([74.125.82.65]:49499 "EHLO
        mail-wm0-f65.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1754604AbdJPQN2 (ORCPT
        <rfc822;linux-unionfs@vger.kernel.org>);
        Mon, 16 Oct 2017 12:13:28 -0400
Received: by mail-wm0-f65.google.com with SMTP id b189so4914597wmd.4
        for <linux-unionfs@vger.kernel.org>; Mon, 16 Oct 2017 09:13:27 -0700 (PDT)
Sender: linux-unionfs-owner@vger.kernel.org
List-Id: linux-unionfs@vger.kernel.org
To: miklos@szeredi.hu, linux-unionfs@vger.kernel.org
Cc: Lukas Rupprecht <Lukas.Rupprecht@ibm.com>, Vasily <vtarasov@us.ibm.com>, Douglas Thain <dthain@nd.edu>, Dean Hildebrand <seattleplus@gmail.com>, dimitrios.skourtis@ibm.com, mmohamed@us.ibm.com, aswarke@us.ibm.com

Hi Miklos,

We are developing a docker related system that requires to union
directories on NFS and local filesystem.  I successfully created a
overlayfs that has lower layer located on NFS and upper layer located
on the local file system. But when I tried to create new files in the
directory located on NFS, I got error message: "Operation not
supported". Does that mean I can not create new files inside the
directory located on NFS? But base on the documentation of overlayfs,
lower layer does not need to be writable.

Steps to reproduce the problem are (/mnt/nfs is the NFS mount,
/home/zc is the local mount)

1. create directory "/mnt/nfs/lower/lower_dir"

2. create directories "/home/zc/upper/upper_dir", "/home/zc/work" and
"/home/zc/merged"

3. create overlayfs by running command

mount -t overlay overlay -o\
lowerdir=/mnt/nfs/lower,\
upperdir=/home/zc/upper,\
workdir=/home/zc/work \
/home/zc/merged

4. Try to create new file "/merged/lower_dir/test.txt" and get error
message "Operation not supported"

Thanks,
Charles
