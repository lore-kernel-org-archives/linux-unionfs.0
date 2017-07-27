From: Miklos Szeredi <miklos@szeredi.hu>
Subject: xattr hash error in 4.13-rc with overlayfs over ext4
Date: Thu, 27 Jul 2017 14:37:35 +0200
Message-ID: <CAJfpegvQhuMnt=2TtfYSiMV=DTLLLbOfrvcR2xQrmvyPU9wSNg@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Return-path: <linux-kernel-owner@vger.kernel.org>
Sender: linux-kernel-owner@vger.kernel.org
To: Tahsin Erdogan <tahsin@google.com>
Cc: Theodore Ts'o <tytso@mit.edu>, "linux-ext4@vger.kernel.org" <linux-ext4@vger.kernel.org>, linux-fsdevel@vger.kernel.org, linux-kernel@vger.kernel.org, "linux-unionfs@vger.kernel.org" <linux-unionfs@vger.kernel.org>
List-Id: linux-unionfs@vger.kernel.org

I get the following error on fsck:

Pass 1: Checking inodes, blocks, and sizes
Extended attribute in inode 3093 has a hash (2257320705) which is invalid
Clear<y>? yes
Inode 3093, i_blocks is 16, should be 8.  Fix<y>? yes

To reproduce:

[mount ext4 image]
mkdir xattrhashtest
cd xattrhashtest/
mkdir upper lower work mnt
cd lower/
echo foo > bar
ln bar baz
mount -t overlay overlay -olowerdir=lower,upperdir=upper,workdir=work mnt
cd mnt/
echo xxx >> bar
[umount and fsck]

Reverting commit daf8328172df ("ext4: eliminate xattr entry e_hash
recalculation for removes") fixes it.

Might be an ext4 or overlayfs bug.  Let me know what you think.

Thanks,
Miklos
