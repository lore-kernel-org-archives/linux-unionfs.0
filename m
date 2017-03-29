From: Richard Weinberger <richard@nod.at>
Subject: Re: [REGRESSION 4.11] Commit d8514d8edb5b ("ovl: copy up regular file
 using O_TMPFILE") breaks ubifs
Date: Thu, 30 Mar 2017 00:15:31 +0200
Message-ID: <33155efb-2c42-a7e9-b867-06760b1e1495@nod.at>
References: <20170328100107.25095af6@gmail.com>
 <CAOQ4uxisw5vWYsdMTNemw=MqNyS2nxfAUkg+UfoGmbE3-he1Ug@mail.gmail.com>
 <20170328124545.3c4b87ff@gmail.com>
 <CAOQ4uxgNfuLN93owdCUJ=9VcU4DKGVEKkEGT7siiem8quVwCsQ@mail.gmail.com>
 <20170328132818.05871b73@gmail.com>
 <CAOQ4uxiC=RXPwSy7NGt+Ri=Eie4-_WsUPk7Sy-sh9RdrGQuesw@mail.gmail.com>
 <20170328141621.6bb2d639@gmail.com>
 <CAOQ4uxg0xRchsNOh1jtbyEdyDDqV3ToCvo=+QuCsD6duGJU_ZQ@mail.gmail.com>
 <20170329232648.0b5bc1e9@gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=windows-1252
Content-Transfer-Encoding: 8bit
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <20170329232648.0b5bc1e9@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
To: Ralph Sennhauser <ralph.sennhauser@gmail.com>, Amir Goldstein <amir73il@gmail.com>
Cc: Miklos Szeredi <miklos@szeredi.hu>, linux-unionfs@vger.kernel.org, linux-kernel <linux-kernel@vger.kernel.org>, linux-mtd@lists.infradead.org, regressions@leemhuis.info, Artem Bityutskiy <dedekind1@gmail.com>, Adrian Hunter <adrian.hunter@intel.com>, David Oberhollenzer <goliath@sigma-star.at>
List-Id: linux-unionfs@vger.kernel.org

Ralph,

Am 29.03.2017 um 23:26 schrieb Ralph Sennhauser:
>> # create and link a tmpfile - then remove it
>> sudo rm -rf foo; sudo xfs_io -T -c "flink foo" . ; ls -l foo; sudo rm
>> foo
> 
> next-20170328, obviously without your patch:
> 
>   # xfs_io -T -c "flink foo" .
>   .: Not supported

-T tells xfs_io to create a tmpfile but you have it disabled in UBIFS.

Anyway, can you please test the attached patch?
Amir was right, UBIFS misses a corner case in ubifs_link(). ;-\

I think I understand also why we never noticed this in xfstests, UBIFS prints
only a non-fatal error while umounting the filesystem in this case.
But will test tomorrow in more detail, need some sleep now.

diff --git a/fs/ubifs/dir.c b/fs/ubifs/dir.c
index 30825d882aa9..95e348a2da29 100644
--- a/fs/ubifs/dir.c
+++ b/fs/ubifs/dir.c
@@ -748,6 +748,9 @@ static int ubifs_link(struct dentry *old_dentry, struct inode *dir,
 		goto out_fname;

 	lock_2_inodes(dir, inode);
+	if (inode->i_nlink == 0)
+		ubifs_delete_orphan(c, inode->i_ino);
+
 	inc_nlink(inode);
 	ihold(inode);
 	inode->i_ctime = ubifs_current_time(inode);

Thanks,
//richard
