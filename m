Return-Path: <eddiehorng.tw@gmail.com>
MIME-Version: 1.0
From: Eddie Horng <eddiehorng.tw@gmail.com>
Date: Tue, 26 Feb 2019 14:31:35 +0800
Message-ID: <CALLuPvpzHUHH3R8DkQS35NSn76fd_An_7EPkY919m3a0oaLTrg@mail.gmail.com>
Subject: real_inode->i_fop->llseek is not called by ovl_llseek
Content-Type: text/plain; charset="UTF-8"
To: Amir Goldstein <amir73il@gmail.com>, Miklos Szeredi <miklos@szeredi.hu>, overlayfs <linux-unionfs@vger.kernel.org>
List-ID: <linux-unionfs@vger.kernel.org>

Hello,
Seems real_inode->i_fop->llseek is not called by ovl_llseek?
It happens the lower fs implements llseek similar with ovl_llseek or lower fs
is overlayfs, the "real inode"  s_maxbytes is not passed to
generic_file_llseek_size. Generally it is not a problem, but is it
better to check if realinode has llseek and invoke it?

static loff_t ovl_llseek(struct file *file, loff_t offset, int whence)
{
struct inode *realinode = ovl_inode_real(file_inode(file));

return generic_file_llseek_size(file, offset, whence,
realinode->i_sb->s_maxbytes,
i_size_read(realinode));
}

thanks,
Eddie
