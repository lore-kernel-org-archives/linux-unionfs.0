Return-Path: <viro@ftp.linux.org.uk>
Date: Fri, 18 May 2018 16:02:19 +0100
From: Al Viro <viro@ZenIV.linux.org.uk>
Subject: Re: [PATCH v4 7/9] vfs: export alloc_inode() and destroy_inode()
Message-ID: <20180518150219.GR30522@ZenIV.linux.org.uk>
References: <1526632177-28832-1-git-send-email-amir73il@gmail.com>
 <1526632177-28832-8-git-send-email-amir73il@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1526632177-28832-8-git-send-email-amir73il@gmail.com>
Sender: Al Viro <viro@ftp.linux.org.uk>
To: Amir Goldstein <amir73il@gmail.com>
Cc: Miklos Szeredi <miklos@szeredi.hu>, Vivek Goyal <vgoyal@redhat.com>, linux-unionfs@vger.kernel.org
List-ID: <linux-unionfs@vger.kernel.org>

On Fri, May 18, 2018 at 11:29:35AM +0300, Amir Goldstein wrote:
> They are needed by overlayfs.

NAK, and kindly abstain from patently false declarative statements
in commit messages.
