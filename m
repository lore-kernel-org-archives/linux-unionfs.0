From: Vivek Goyal <vgoyal@redhat.com>
Subject: Re: [PATCH v10 07/18] ovl: Add mechanism to create a chain of origin
 dentries
Date: Tue, 30 Jan 2018 15:06:50 -0500
Message-ID: <20180130200650.GD7929@redhat.com>
References: <20180122184004.26026-1-vgoyal@redhat.com>
 <20180122184004.26026-8-vgoyal@redhat.com>
 <CAOQ4uxiAbz479QygqeJGcbZdO2y1apJo3SqXAXby05c9z2Q85Q@mail.gmail.com>
 <CAOQ4uxgf0Nh7tQNN=vHmxOQvN8+=ogBjB5HrPs8gDfTeN8eonw@mail.gmail.com>
 <20180123134537.GC2755@redhat.com>
 <CAOQ4uxhU15nXU32+q6_krm=c_xY=OBaAmJF4xk7CMbeDur4oKw@mail.gmail.com>
 <20180130193356.GC7929@redhat.com>
 <CAOQ4uxjc12UkMDRtRsbWiUkhU4306k5cVhpBp386NrOGaSURZw@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-unionfs-owner@vger.kernel.org>
Received: from mx1.redhat.com ([209.132.183.28]:34624 "EHLO mx1.redhat.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1752793AbeA3UGv (ORCPT <rfc822;linux-unionfs@vger.kernel.org>);
        Tue, 30 Jan 2018 15:06:51 -0500
Content-Disposition: inline
In-Reply-To: <CAOQ4uxjc12UkMDRtRsbWiUkhU4306k5cVhpBp386NrOGaSURZw@mail.gmail.com>
Sender: linux-unionfs-owner@vger.kernel.org
List-Id: linux-unionfs@vger.kernel.org
To: Amir Goldstein <amir73il@gmail.com>
Cc: overlayfs <linux-unionfs@vger.kernel.org>, Miklos Szeredi <miklos@szeredi.hu>

On Tue, Jan 30, 2018 at 10:03:19PM +0200, Amir Goldstein wrote:
> On Tue, Jan 30, 2018 at 9:33 PM, Vivek Goyal <vgoyal@redhat.com> wrote:
> > On Tue, Jan 23, 2018 at 03:47:29PM +0200, Amir Goldstein wrote:
> >> On Tue, Jan 23, 2018 at 3:45 PM, Vivek Goyal <vgoyal@redhat.com> wrote:
> >> > On Mon, Jan 22, 2018 at 09:46:33PM +0200, Amir Goldstein wrote:
> >> >> On Mon, Jan 22, 2018 at 9:34 PM, Amir Goldstein <amir73il@gmail.com> wrote:
> >> >> > On Mon, Jan 22, 2018 at 8:39 PM, Vivek Goyal <vgoyal@redhat.com> wrote:
> >> >> >> There is a need to support metacopy dentry in midlayer. That means there
> >> >> >> could be a chain of metacopy dentries.
> >> >> >>
> >> >> >> For example, upper could be metacopy, midlayer lower could be metacopy and
> >> >> >> lowest layer could be actual data inode. This means when we copy up actual
> >> >> >> data, we should be able to reach to lowest data inode and copy up data from
> >> >> >> there. And that means we should keep track of all the dentries in origin
> >> >> >> chain which lead to data inode.
> >> >> >>
> >> >> >> Current ovl_check_origin() logic only looks for one origin dentry. This patch
> >> >> >> enhances ovl_check_origin() to continue to follow origin chain and return
> >> >> >> all the origin entries found. This is done only if caller of the function
> >> >> >> set "follow_chain" argument.
> >> >> >>
> >> >> >
> >> >> > We don't really need to keep the entire chain do we?
> >> >> > We can follow chain but keep only the one inode that is not a metacopy inode.
> >> >> > All the rest are useless, no?
> >> >> > Then we don't create a new type of object - non-dir with numlower > 1.
> >> >> >
> >> >>
> >> >> Seems like if you don't keep the entire chain, then no need for
> >> >> patches 14 and 15.
> >> >
> >> > I will need to have atleast 2 lower dentries. One will be top most
> >> > metadata copy and other lower most data dentry. IOW, both the ends of
> >> > the chain need to be there.
> >> >
> >> >> Also with upper metacopy, you can fix upper origin xattr after
> >> >> following to the data
> >> >> origin and forget about middle layer metacopies forever.
> >> >
> >> > If upper metacopy is alreday there, then I agree that lower top most
> >> > becomes inner node of chain and we can get rid of it.
> >> >
> >> >>
> >> >> Am I missing something?
> >> >
> >> > I think you are missing the case when there is no upper and lower has
> >> > a metacopy chain. In that case we need to retain two dentries. One for
> >> > data copy up and one for metadata copy up.
> >> >
> >>
> >> OK. so you can get rid of all the middle metacopies while following
> >> the origin chain. no reason to keep those.
> >
> > Hi Amir,
> >
> > What about the case when we have upper and one middle metacopy. As of top
> > most lower is the ORIGIN for upper. Should we retain that top most lower
> > ORIGIN as well as lower most data. Or just retain lower most data and
> > use that as ORIGIN.
> >
> 
> Not sure I follow.
> IIUC, the longest possible chain is lowerstack size 2:
> upper -> metadata ORIGIN -> data ORIGIN
> 
> If this is what you meant than seems ok to me.

Right, that's what I mean. Ok, I will keep it that way.

Vivek
