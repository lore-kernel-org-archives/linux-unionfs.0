From: "J . Bruce Fields" <bfields@fieldses.org>
Subject: Re: [PATCH v2 2/2] nfsd: store stat times in fill_pre_wcc() instead
 of inode times
Date: Fri, 19 Jan 2018 17:03:34 -0500
Message-ID: <20180119220334.GA13700@fieldses.org>
References: <1514992475-8142-1-git-send-email-amir73il@gmail.com>
 <1514992475-8142-3-git-send-email-amir73il@gmail.com>
 <1514994062.3458.14.camel@kernel.org>
 <CAOQ4uxgHwkT=2SGz=XQqP626rfpWCAXtmvBwZuU1N8s1Bh6a4A@mail.gmail.com>
 <1515005144.3458.42.camel@kernel.org>
 <CAOQ4uxg86oNAYXLN8iCFJTVOV7nxp9a8AwrQPhvr1M-dWqWErA@mail.gmail.com>
 <1515072403.20282.16.camel@kernel.org>
 <20180104230513.GA19858@fieldses.org>
 <CAOQ4uxh_grPq9LNQkUa7NDXy22dBnNWqJprDSi1Wm20vyFyUFg@mail.gmail.com>
 <20180105153018.GB28246@fieldses.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-fsdevel-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <20180105153018.GB28246@fieldses.org>
Sender: linux-fsdevel-owner@vger.kernel.org
To: Amir Goldstein <amir73il@gmail.com>
Cc: Jeff Layton <jlayton@kernel.org>, Miklos Szeredi <miklos@szeredi.hu>, overlayfs <linux-unionfs@vger.kernel.org>, linux-fsdevel <linux-fsdevel@vger.kernel.org>
List-Id: linux-unionfs@vger.kernel.org

On Fri, Jan 05, 2018 at 10:30:18AM -0500, J . Bruce Fields wrote:
> On Fri, Jan 05, 2018 at 04:45:46PM +0200, Amir Goldstein wrote:
> > So can I assume you will be taking both patches through your tree?
> > and add said comment to your future self?
> 
> I'm OK with that (if Jeff is).
> 
> > Since patches are independent of overlayfs work, it does not matter if they
> > get merged before or after overlayfs work, just please let us know what you
> > intend to do, because right now I posted patch 1/2 at the end of the
> > overlayfs series for Miklos to take.
> 
> I'd be fine with that or with Miklos taking either or both (feel free to
> add an Acked-by: tag for me if you take that route).
> 
> But I'll assume I'm taking them unless I hear otherwise.

By the way, I just got back to this: committed to nfsd-next at
git://linux-nfs.org/~bfields/linux.git, with just one extra paragraph on
#2's changelog.

--b.
