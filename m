From: Al Viro <viro@ZenIV.linux.org.uk>
Subject: Re: [RFC][PATH 4/4] ovl: relax lock_rename when moving files between
 work and upper dir
Date: Fri, 11 Nov 2016 00:27:56 +0000
Message-ID: <20161111002756.GP19539@ZenIV.linux.org.uk>
References: <1478817883-27662-1-git-send-email-amir73il@gmail.com>
 <1478817883-27662-5-git-send-email-amir73il@gmail.com>
 <20161110230221.GL19539@ZenIV.linux.org.uk>
 <20161110230557.GM19539@ZenIV.linux.org.uk>
 <CAOQ4uxiW=FjRoAaumkjA=5b83rr3Cfu=Yk5nqsDx-qCenHGu3A@mail.gmail.com>
 <20161110231757.GN19539@ZenIV.linux.org.uk>
 <CAOQ4uxgDhyy1z4xJgvA7c_mPvaYiNhi22DHpYM4X2SODtSwP1Q@mail.gmail.com>
 <20161110235444.GO19539@ZenIV.linux.org.uk>
 <CAOQ4uxiR6wsk97jQ43hu=hkJ1JQRaerSSEwjVr8tX6ia-yfOgA@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-unionfs-owner@vger.kernel.org>
Received: from zeniv.linux.org.uk ([195.92.253.2]:46558 "EHLO
        ZenIV.linux.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S965311AbcKKA17 (ORCPT
        <rfc822;linux-unionfs@vger.kernel.org>);
        Thu, 10 Nov 2016 19:27:59 -0500
Content-Disposition: inline
In-Reply-To: <CAOQ4uxiR6wsk97jQ43hu=hkJ1JQRaerSSEwjVr8tX6ia-yfOgA@mail.gmail.com>
Sender: linux-unionfs-owner@vger.kernel.org
List-Id: linux-unionfs@vger.kernel.org
To: Amir Goldstein <amir73il@gmail.com>
Cc: Miklos Szeredi <miklos@szeredi.hu>, Konstantin Khlebnikov <koct9i@gmail.com>, linux-unionfs@vger.kernel.org, linux-fsdevel <linux-fsdevel@vger.kernel.org>

On Fri, Nov 11, 2016 at 02:11:56AM +0200, Amir Goldstein wrote:
> Yeah, I wrote in the cover letter that I did not generate performance
> numbers yet,
> which is a must for this sort of work, and that I am hoping to get some feedback
> from testers.
> But the serialization I am trying to avoid is between copy-ups and whiteouts of
> different overlay mounts, all on the same fs, which is the case with
> docker/rocket
> containers.
> 
> Not ruling out that I am barking up the wrong tree. The burden of
> proof is on me.

Surely, the copying of data itself is outside of that lock, isn't it?
And renames proper, especially if there is any kind of contention going on,
will be on the metadata hot in cache, so I would really like to see the
actual evidence of contention-related performance issues...
