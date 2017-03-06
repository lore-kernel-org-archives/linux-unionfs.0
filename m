From: "J. R. Okajima" <hooanon05g@gmail.com>
Subject: Re: [PATCH v4 1/6] vfs: create vfs helper vfs_tmpfile()
Date: Mon, 06 Mar 2017 23:59:12 +0900
Message-ID: <2523.1488812352@jrobl>
References: <1484627697-17262-1-git-send-email-amir73il@gmail.com> <1484627697-17262-2-git-send-email-amir73il@gmail.com>
Return-path: <linux-fsdevel-owner@vger.kernel.org>
In-Reply-To: <1484627697-17262-2-git-send-email-amir73il@gmail.com>
Sender: linux-fsdevel-owner@vger.kernel.org
To: Amir Goldstein <amir73il@gmail.com>
Cc: Miklos Szeredi <miklos@szeredi.hu>, Al Viro <viro@zeniv.linux.org.uk>, linux-unionfs@vger.kernel.org, linux-fsdevel@vger.kernel.org
List-Id: linux-unionfs@vger.kernel.org

Amir Goldstein:
> Factor out some common vfs bits from do_tmpfile()
> to be used by overlayfs for concurrent copy up.

Hmm, just to copy-up.
I have no objection this factoring-out, but do you have any specific
reason for overlayfs NOT to support i_op->tmpfile()?

If you try supporting it in the future, then the parameter open_flag may
become a problem. I guess that you will make ovl_tmpfile() (currently
not exist) to call vfs_tmpfile(), and pass dummy 0 as open_flag as
overlayfs copy-up does. But such dummy parameter will make the created
tmpfile un-linkable by a user I am afraid.


J. R. Okajima
