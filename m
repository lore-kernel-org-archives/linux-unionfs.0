From: Al Viro <viro@ZenIV.linux.org.uk>
Subject: Re: [RFC][PATH 4/4] ovl: relax lock_rename when moving files between
 work and upper dir
Date: Thu, 10 Nov 2016 23:17:57 +0000
Message-ID: <20161110231757.GN19539@ZenIV.linux.org.uk>
References: <1478817883-27662-1-git-send-email-amir73il@gmail.com>
 <1478817883-27662-5-git-send-email-amir73il@gmail.com>
 <20161110230221.GL19539@ZenIV.linux.org.uk>
 <20161110230557.GM19539@ZenIV.linux.org.uk>
 <CAOQ4uxiW=FjRoAaumkjA=5b83rr3Cfu=Yk5nqsDx-qCenHGu3A@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-fsdevel-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <CAOQ4uxiW=FjRoAaumkjA=5b83rr3Cfu=Yk5nqsDx-qCenHGu3A@mail.gmail.com>
Sender: linux-fsdevel-owner@vger.kernel.org
To: Amir Goldstein <amir73il@gmail.com>
Cc: Miklos Szeredi <miklos@szeredi.hu>, Konstantin Khlebnikov <koct9i@gmail.com>, linux-unionfs@vger.kernel.org, linux-fsdevel <linux-fsdevel@vger.kernel.org>
List-Id: linux-unionfs@vger.kernel.org

On Fri, Nov 11, 2016 at 01:11:16AM +0200, Amir Goldstein wrote:

> That is explained in commit message of the first 2 patches, but
> foremost I would like to say that the name "delete locked" is just the
> best of all the bad choices for names I came up with, so I am expecting
> better name suggestions.
> 
> The concept is to pin the entry so that it cannot be moved, so can have
> certain guaranties about the stability of the directories topology.
> 
> > More specifically, what makes you think that may_delete() is called before
> > any change of parent?
> 
> Because it is checked at the beginning of vfs_rename()
> and in order to change a parent, an entry needs to be renamed. no?
> What am I missing?

Analysis of the rest of call chains where we have __d_move() called?  Not
to mention anything else, workdir itself might be moved around by
d_splice_alias() for a sufficiently unpleasant filesystem...
