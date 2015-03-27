From: David Howells <dhowells@redhat.com>
Subject: Re: [PATCH 12/15] VFS: Add owner-filesystem positive/negative dentry checks
Date: Fri, 27 Mar 2015 14:42:37 +0000
Message-ID: <12393.1427467357@warthog.procyon.org.uk>
References: <CAJfpegue3OvFwxCUiRuGJxCMQV_jrtYoGoZywRz_kLykKbQU4w@mail.gmail.com> <20150325144330.17670.6959.stgit@warthog.procyon.org.uk> <20150325144524.17670.21070.stgit@warthog.procyon.org.uk>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <CAJfpegue3OvFwxCUiRuGJxCMQV_jrtYoGoZywRz_kLykKbQU4w@mail.gmail.com>
Content-ID: <12392.1427467357.1@warthog.procyon.org.uk>
Sender: linux-kernel-owner@vger.kernel.org
To: Miklos Szeredi <miklos@szeredi.hu>
Cc: dhowells@redhat.com, viro@ftp.linux.org.uk, "linux-unionfs@vger.kernel.org" <linux-unionfs@vger.kernel.org>, Kernel Mailing List <linux-kernel@vger.kernel.org>
List-Id: linux-unionfs@vger.kernel.org

Miklos Szeredi <miklos@szeredi.hu> wrote:

> I think this is confusing as hell, there needs to be more consistency
> in the naming.  E.g. d_backing_is_positive() vs. d_is_positive().   I
> know it's the other way round now, but only with a few users.

Yeah.  The problem is that all of:

	__d_entry_type()
	d_is_miss()
	d_is_whiteout()
	d_can_lookup()
	d_is_autodir()
	d_is_dir()
	d_is_symlink()
	d_is_reg()
	d_is_special()
	d_is_file()
	d_is_negative()
	d_is_positive()

refer to the 'backing' inode (if there is one) in the case that you have a
unionmount and the top dentry's ->d_inode is NULL.  (Well, technically, that
doesn't happen in the case of directories)

Of course, if we decide we aren't going to do unionmount, certain things
become simpler.

> Also a separate include file might help, that needs explicit including to
> get the "backing" variants

I would like to see a 'for fs implementer' header and a 'for fs user' header
but Al didn't like that last time I suggested it.

However, it doesn't help with the naming since there are situations where you
need *both* - eg. overlayfs.

> and which would have big fat warnings all over.

Well, we could argue about which side should have the warnings.

David
