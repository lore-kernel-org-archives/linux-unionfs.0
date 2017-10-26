From: Vivek Goyal <vgoyal@redhat.com>
Subject: Re: [PATCH 04/13] ovl: Provide a mount option metacopy=on/off for
 metadata copyup
Date: Thu, 26 Oct 2017 09:15:05 -0400
Message-ID: <20171026131505.GB28005@redhat.com>
References: <1508958575-14086-1-git-send-email-vgoyal@redhat.com>
 <1508958575-14086-5-git-send-email-vgoyal@redhat.com>
 <CAOQ4uxhV3-8ytms+M5n2QVYGmZJNL527H7KYpXnzbE93fOsBdA@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-unionfs-owner@vger.kernel.org>
Received: from mx1.redhat.com ([209.132.183.28]:42298 "EHLO mx1.redhat.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S932206AbdJZNPG (ORCPT <rfc822;linux-unionfs@vger.kernel.org>);
        Thu, 26 Oct 2017 09:15:06 -0400
Content-Disposition: inline
In-Reply-To: <CAOQ4uxhV3-8ytms+M5n2QVYGmZJNL527H7KYpXnzbE93fOsBdA@mail.gmail.com>
Sender: linux-unionfs-owner@vger.kernel.org
List-Id: linux-unionfs@vger.kernel.org
To: Amir Goldstein <amir73il@gmail.com>
Cc: overlayfs <linux-unionfs@vger.kernel.org>, Miklos Szeredi <miklos@szeredi.hu>

On Thu, Oct 26, 2017 at 08:39:28AM +0300, Amir Goldstein wrote:
> On Wed, Oct 25, 2017 at 10:09 PM, Vivek Goyal <vgoyal@redhat.com> wrote:
> > By default metadata only copy up is disabled. Provide a mount option so
> > that users can choose one way or other.
> >
> > Also provide a kernel config and module option to enable/disable
> > metacopy feature.
> >
> > Like index feature, when overlay is mounted, on root upper directory we
> > set ORIGIN which points to lower. And at later mount time it is verified
> > again. This hopes to get the configuration right. But this does only so
> > much as we don't verify all the lowers. So it is possible that a lower is
> > missing and later data copy up fails.
> 
> Since you bother to specify the motivation for verifying lower root dir,
> FYI, the main motivation was to detect the case of copied layers.

What are copied layers? You mean I remove original layer and bring in
another one with same top dir name?

But this tests only one layer, right. So if there are multiple lower
layers, I can still copy/remove or do something else with other layers
and it will not detect.

Also I should be able to retain top dir name same and replace anything
underneath and that will not be detected either.

So it provides only so much of protection, IIUC.

> I still hold the opinion that new incompat features should enforce
> exclusive dir lock, so withholding Reviewed-by on this one for now.

I am really not happy about enforcing exlusive dir lock because
this breaks userspace. 

I like the idea of making it hard to get configuration wrong, but overlay
was like this since the beginning and how many issues have we faced
that users ended up sharing upper. Atleast I have not come across
even a single one.

If that's the case, I would rahter wait that a proper fix comes along
(finding existing super block and returning that) and then harden it.

If I enforce it now, I most likely can't even use it with current
container run time because there is a possibility they can leak
mount points. So what's the point of introducing this feature.

Miklos, what do you think?

Vivek
