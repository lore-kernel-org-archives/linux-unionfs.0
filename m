Return-Path: <zohar@linux.ibm.com>
Subject: Re: PROBLEM: IMA xattrs not written on overlayfs
From: Mimi Zohar <zohar@linux.ibm.com>
Date: Fri, 07 Sep 2018 14:45:54 -0400
In-Reply-To: <81a0a75d-bd4e-25ef-b41b-adb65ac6dee8@suse.de>
References: <81a0a75d-bd4e-25ef-b41b-adb65ac6dee8@suse.de>
Content-Type: text/plain; charset="UTF-8"
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Message-Id: <1536345954.3792.173.camel@linux.ibm.com>
To: Ignaz Forster <iforster@suse.de>, miklos@szeredi.hu, linux-unionfs@vger.kernel.org, zohar@linux.vnet.ibm.com, linux-integrity@vger.kernel.org
List-ID: <linux-unionfs@vger.kernel.org>

On Fri, 2018-09-07 at 18:49 +0200, Ignaz Forster wrote:
> Hi,
> 
> I'm currently experimenting with IMA / EVM on overlayfs, however those 
> don't seem to work together very well.
> 
> With kernel 4.18 it was possible to at least partially use IMA. As long 
> as the O_TRUNC attribute was not set during a copy_up operation 
> everything seemed to work so far.
> 
> Now when applying the changes from 
> https://git.kernel.org/pub/scm/linux/kernel/git/mszeredi/vfs.git/tag/?h=ovl-update-4.19 
> (or using kernel 4.19-rc2) every file contents modification or creation 
> of a new file will fail, probably because the inode reported by 
> overlayfs does not match the physical inode number any more (and thus 
> the IMA hashes won't be generated).
> 
> 
> A small example for reproduction (on a system with IMA appraisal):
> # OVERLAYFS_TEST_DIR=`mktemp -d`
> # mkdir "${OVERLAYFS_TEST_DIR}/upper"
> # mkdir "${OVERLAYFS_TEST_DIR}/work"
> # mount -t overlay -o lowerdir=/etc,upperdir="${OVERLAYFS_TEST_DIR} 
> /upper",workdir="${OVERLAYFS_TEST_DIR}/work" overlay /etc
> #
> # rm -f /etc/test.txt
> # echo Test > /etc/test.txt
> # cat /etc/test.txt
> cat: /etc/test.txt: Permission denied
> # ls -s /etc/test.txt
> 4 /etc/test.txt # <- The contents are there
> # getfattr -m . -d /etc/test.txt
> # # <- The hash isn't
> 

Thank you for providing the example.  Also on a linux-4.18.0-rcX test
kernel, the file hash isn't being written out either.  The builtin
"appraise_tcb" policy (eg. specified as "ima_policy=appraise_tcb" on
the boot command) has a tmpfs dont_appraise rule.

> After some debugging I'm not sure on how to continue from here. My 
> assumption is that overlayfs will have to be modified, however I fail to 
> see where to start.

Please make sure that you're comparing the results based on using the
same IMA policy.

Mimi
