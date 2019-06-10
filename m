Return-Path: <linux-unionfs-owner@vger.kernel.org>
Received: from mx1.redhat.com ([209.132.183.28]:39836 "EHLO mx1.redhat.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2387643AbfFJSpy (ORCPT <rfc822;linux-unionfs@vger.kernel.org>);
        Mon, 10 Jun 2019 14:45:54 -0400
Date: Mon, 10 Jun 2019 14:45:53 -0400
From: Vivek Goyal <vgoyal@redhat.com>
Subject: Re: [PATCH v2] overlay: allow config override of metacopy/redirect
 defaults
Message-ID: <20190610184553.GE25290@redhat.com>
References: <20190607010431.11868-1-mcoffin13@gmail.com>
 <20190607205105.21858-1-mcoffin13@gmail.com>
 <CAOQ4uximPqsNivkqD36LdNfT4g41v2rtDm+OB6t2z40dpWs_og@mail.gmail.com>
 <f5b0bddd-678b-bdd9-6fc7-cc9e5b3211e5@gmail.com>
 <CAOQ4uxjQQcrcpxhtu3kAJvGaK+xd5TfNB=7_UnNciGj990DN6Q@mail.gmail.com>
 <CAJfpegvy-Vfc6AEP7+=VfUtfL4izY8AzgoUdvqP4PHnLDEQhNg@mail.gmail.com>
 <20190610184043.GD25290@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20190610184043.GD25290@redhat.com>
Sender: linux-unionfs-owner@vger.kernel.org
To: Miklos Szeredi <miklos@szeredi.hu>
Cc: Amir Goldstein <amir73il@gmail.com>, Matt Coffin <mcoffin13@gmail.com>, overlayfs <linux-unionfs@vger.kernel.org>, Daniel J Walsh <dwalsh@redhat.com>
List-ID: <linux-unionfs@vger.kernel.org>

On Mon, Jun 10, 2019 at 02:40:43PM -0400, Vivek Goyal wrote:
> On Sun, Jun 09, 2019 at 09:14:38PM +0200, Miklos Szeredi wrote:
> > On Sat, Jun 8, 2019 at 8:47 PM Amir Goldstein <amir73il@gmail.com> wrote:
> > 
> > > And then every time that a feature needs to be turned off for some reason
> > > that also needs to be taken into account.
> > > IOW, I advise against diving into this mess. You have been warned ;-)
> > 
> > Also a much more productive direction would be to optimize building
> > the docker image based on the specific format used by overlayfs for
> > readirect_dir/metacopy.
> > 
> > To me it seems like a no-brainer, but I don't know much about docker, so...
> 
> [ cc Daniel Walsh]
> 
> Hi Miklos,
> 
> Can you elaborate a bit more on what docker/container-storoage and do
> here to expedite image generation with redirect_dir/metacopy enabled.
> 
> They can't pack these xattrs in image because image will not be portable.
> It will be overlayfs specific and can't be made to work on target without
> overlayfs.

Are you referring to apps being able to traverse lower layers and do
the redirect_dir and metacopy resoltion as kernel does. To me that process
is not trivial. Having a library might help with adoption though.

Vivek
