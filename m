From: Al Viro <viro@ZenIV.linux.org.uk>
Subject: Re: [PATCH v3 1/6] vfs: create vfs helper vfs_tmpfile()
Date: Sun, 19 Feb 2017 03:27:45 +0000
Message-ID: <20170219032743.GH29622@ZenIV.linux.org.uk>
References: <1484588765-9397-1-git-send-email-amir73il@gmail.com>
 <1484588765-9397-2-git-send-email-amir73il@gmail.com>
 <CAJfpegsDzNot=z8oP7DecuXtNkYPYOejDWWXs6KjD6=Le=Wohg@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-unionfs-owner@vger.kernel.org>
Received: from zeniv.linux.org.uk ([195.92.253.2]:55876 "EHLO
        ZenIV.linux.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751012AbdBSD2h (ORCPT
        <rfc822;linux-unionfs@vger.kernel.org>);
        Sat, 18 Feb 2017 22:28:37 -0500
Content-Disposition: inline
In-Reply-To: <CAJfpegsDzNot=z8oP7DecuXtNkYPYOejDWWXs6KjD6=Le=Wohg@mail.gmail.com>
Sender: linux-unionfs-owner@vger.kernel.org
List-Id: linux-unionfs@vger.kernel.org
To: Miklos Szeredi <miklos@szeredi.hu>
Cc: Amir Goldstein <amir73il@gmail.com>, "linux-unionfs@vger.kernel.org" <linux-unionfs@vger.kernel.org>, linux-fsdevel@vger.kernel.org

On Mon, Jan 16, 2017 at 08:47:32PM +0100, Miklos Szeredi wrote:

> > +                          umode_t mode, int open_flag)
> > +{
> > +       static const struct qstr name = QSTR_INIT("/", 1);
> > +       struct dentry *child = NULL;
> > +       struct inode *inode;
> > +       int error;
> > +
> > +       /* we want directory to be writable */
> > +       error = inode_permission(dir, MAY_WRITE | MAY_EXEC);
> 
> This is not in the scope of this patch, but shoudln't we be using
> may_create() here?   Or at least a variant without the audit thing...
> 
> Al?

may_create() expects directory + child dentry; here we have only parent.
IS_DEADDIR is rather pointless here - directory is not locked, for
starters, so rmdir might happen right under you.  Or right after you've
returned from your function, for that matter.  userns checks...
FWIW, no such checks are done in ->atomic_open() paths, so I'm not sure
how much are those worth...
