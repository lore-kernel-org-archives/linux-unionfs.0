From: Al Viro <viro@ZenIV.linux.org.uk>
Subject: Re: [RFC][PATH 4/4] ovl: relax lock_rename when moving files between
 work and upper dir
Date: Thu, 10 Nov 2016 23:54:44 +0000
Message-ID: <20161110235444.GO19539@ZenIV.linux.org.uk>
References: <1478817883-27662-1-git-send-email-amir73il@gmail.com>
 <1478817883-27662-5-git-send-email-amir73il@gmail.com>
 <20161110230221.GL19539@ZenIV.linux.org.uk>
 <20161110230557.GM19539@ZenIV.linux.org.uk>
 <CAOQ4uxiW=FjRoAaumkjA=5b83rr3Cfu=Yk5nqsDx-qCenHGu3A@mail.gmail.com>
 <20161110231757.GN19539@ZenIV.linux.org.uk>
 <CAOQ4uxgDhyy1z4xJgvA7c_mPvaYiNhi22DHpYM4X2SODtSwP1Q@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-fsdevel-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <CAOQ4uxgDhyy1z4xJgvA7c_mPvaYiNhi22DHpYM4X2SODtSwP1Q@mail.gmail.com>
Sender: linux-fsdevel-owner@vger.kernel.org
To: Amir Goldstein <amir73il@gmail.com>
Cc: Miklos Szeredi <miklos@szeredi.hu>, Konstantin Khlebnikov <koct9i@gmail.com>, linux-unionfs@vger.kernel.org, linux-fsdevel <linux-fsdevel@vger.kernel.org>
List-Id: linux-unionfs@vger.kernel.org

On Fri, Nov 11, 2016 at 01:33:08AM +0200, Amir Goldstein wrote:

> I am certainly looking for this feedback, because there is no other means for
> me to sanity test if relaxing lock_rename() is safe.
> 
> When I write "any change of parent" I mean a change between 2 different
> connected parents. Both work dir and upper dir are connected and with
> reference held after mount.
> Are the d_splice_alias() and __d_unalias() cases a real concern for moving
> work dir around after the overlay mount??

Why not?  Again, it's really up to you to provide an analysis of the call
chains.  There's nothing in d_splice_alias() to prohibit an existing alias
being attached - in fact, __d_unalias() is called exactly in that case.
It's a rare case, all right, but it is not impossible.

BTW, your analysis would better be simple and explicit - anything subtle
will be flat-out rejected, since it would have to be stepped around very
carefully in any later work in VFS.

I really wonder what it is that you are getting contention on - what are
you doing, besides the actual renames?  And that needs serialization anyway
(on inode lock of workdir, if nothing else), so any contention would not
disappear from dropped ->s_vfs_rename_mutex...
