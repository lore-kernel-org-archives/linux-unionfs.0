Return-Path: <linux-unionfs-owner@vger.kernel.org>
Received: from mx2.suse.de ([195.135.220.15]:38084 "EHLO mx1.suse.de"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1726032AbeIGVbU (ORCPT <rfc822;linux-unionfs@vger.kernel.org>);
        Fri, 7 Sep 2018 17:31:20 -0400
From: Ignaz Forster <iforster@suse.de>
Subject: PROBLEM: IMA xattrs not written on overlayfs
Message-ID: <81a0a75d-bd4e-25ef-b41b-adb65ac6dee8@suse.de>
Date: Fri, 7 Sep 2018 18:49:32 +0200
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-GB
Content-Transfer-Encoding: 7bit
Sender: linux-unionfs-owner@vger.kernel.org
To: miklos@szeredi.hu, linux-unionfs@vger.kernel.org, zohar@linux.vnet.ibm.com, linux-integrity@vger.kernel.org
List-ID: <linux-unionfs@vger.kernel.org>

Hi,

I'm currently experimenting with IMA / EVM on overlayfs, however those 
don't seem to work together very well.

With kernel 4.18 it was possible to at least partially use IMA. As long 
as the O_TRUNC attribute was not set during a copy_up operation 
everything seemed to work so far.

Now when applying the changes from 
https://git.kernel.org/pub/scm/linux/kernel/git/mszeredi/vfs.git/tag/?h=ovl-update-4.19 
(or using kernel 4.19-rc2) every file contents modification or creation 
of a new file will fail, probably because the inode reported by 
overlayfs does not match the physical inode number any more (and thus 
the IMA hashes won't be generated).


A small example for reproduction (on a system with IMA appraisal):
# OVERLAYFS_TEST_DIR=`mktemp -d`
# mkdir "${OVERLAYFS_TEST_DIR}/upper"
# mkdir "${OVERLAYFS_TEST_DIR}/work"
# mount -t overlay -o lowerdir=/etc,upperdir="${OVERLAYFS_TEST_DIR} 
/upper",workdir="${OVERLAYFS_TEST_DIR}/work" overlay /etc
#
# rm -f /etc/test.txt
# echo Test > /etc/test.txt
# cat /etc/test.txt
cat: /etc/test.txt: Permission denied
# ls -s /etc/test.txt
4 /etc/test.txt # <- The contents are there
# getfattr -m . -d /etc/test.txt
# # <- The hash isn't


After some debugging I'm not sure on how to continue from here. My 
assumption is that overlayfs will have to be modified, however I fail to 
see where to start.

Ignaz
