From: Al Viro <viro@ZenIV.linux.org.uk>
Subject: Re: [RFC][PATH 4/4] ovl: relax lock_rename when moving files between
 work and upper dir
Date: Fri, 11 Nov 2016 15:40:34 +0000
Message-ID: <20161111154034.GR19539@ZenIV.linux.org.uk>
References: <1478817883-27662-5-git-send-email-amir73il@gmail.com>
 <20161110230221.GL19539@ZenIV.linux.org.uk>
 <20161110230557.GM19539@ZenIV.linux.org.uk>
 <CAOQ4uxiW=FjRoAaumkjA=5b83rr3Cfu=Yk5nqsDx-qCenHGu3A@mail.gmail.com>
 <20161110231757.GN19539@ZenIV.linux.org.uk>
 <CAOQ4uxgDhyy1z4xJgvA7c_mPvaYiNhi22DHpYM4X2SODtSwP1Q@mail.gmail.com>
 <20161110235444.GO19539@ZenIV.linux.org.uk>
 <CAOQ4uxiR6wsk97jQ43hu=hkJ1JQRaerSSEwjVr8tX6ia-yfOgA@mail.gmail.com>
 <20161111002756.GP19539@ZenIV.linux.org.uk>
 <CAOQ4uxibJf7BVSOeRdfcE7VtU2rkrii=Pu9OL0uZPavpudODeQ@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-unionfs-owner@vger.kernel.org>
Received: from zeniv.linux.org.uk ([195.92.253.2]:35672 "EHLO
        ZenIV.linux.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1754181AbcKKPkh (ORCPT
        <rfc822;linux-unionfs@vger.kernel.org>);
        Fri, 11 Nov 2016 10:40:37 -0500
Content-Disposition: inline
In-Reply-To: <CAOQ4uxibJf7BVSOeRdfcE7VtU2rkrii=Pu9OL0uZPavpudODeQ@mail.gmail.com>
Sender: linux-unionfs-owner@vger.kernel.org
List-Id: linux-unionfs@vger.kernel.org
To: Amir Goldstein <amir73il@gmail.com>
Cc: Miklos Szeredi <miklos@szeredi.hu>, Konstantin Khlebnikov <koct9i@gmail.com>, linux-unionfs@vger.kernel.org, linux-fsdevel <linux-fsdevel@vger.kernel.org>

On Fri, Nov 11, 2016 at 04:43:57PM +0200, Amir Goldstein wrote:

> > Surely, the copying of data itself is outside of that lock, isn't it?
> 
> Mmmmmm, no it isn't, but I am going to make it right.

Well, if you really have the copyup itself done under lock_rename(), you
are looking at potentially copying gigabytes of data from r/o layer to
workdir under fs-wide lock.  _That_ is really asking for contention from
hell, and for no good reason.  Renames/whiteout creations/removals are
trivial noise compared to that.  I'm somewhat surprised, TBH - I thought
the copyup itself is done outside of that thing.  Are you sure it really
isn't?
