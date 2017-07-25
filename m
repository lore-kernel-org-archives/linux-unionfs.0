From: Greg KH <greg@kroah.com>
Subject: Re: [PATCH v2] ovl: drop CAP_SYS_RESOURCE from saved mounter's
 credentials
Date: Mon, 24 Jul 2017 20:47:58 -0700
Message-ID: <20170725034758.GA9808@kroah.com>
References: <148404760886.4400.14907571208759802396.stgit@buzz>
 <148407302133.16047.411379729888561193.stgit@buzz>
 <20170110191721.GF23108@redhat.com>
 <CAOQ4uxg9x9Vj0K+tz2nCmLc9-O55LDD9-nQUdXjrEJCzyxAx=g@mail.gmail.com>
 <CAJfpeguZX65k1SV0K63bfEhsGgYeybrmJ73fx7wyEB1kVUyuow@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-unionfs-owner@vger.kernel.org>
Received: from out1-smtp.messagingengine.com ([66.111.4.25]:33291 "EHLO
        out1-smtp.messagingengine.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1755734AbdGYDsG (ORCPT
        <rfc822;linux-unionfs@vger.kernel.org>);
        Mon, 24 Jul 2017 23:48:06 -0400
Content-Disposition: inline
In-Reply-To: <CAJfpeguZX65k1SV0K63bfEhsGgYeybrmJ73fx7wyEB1kVUyuow@mail.gmail.com>
Sender: linux-unionfs-owner@vger.kernel.org
List-Id: linux-unionfs@vger.kernel.org
To: Miklos Szeredi <miklos@szeredi.hu>
Cc: Amir Goldstein <amir73il@gmail.com>, Vivek Goyal <vgoyal@redhat.com>, Konstantin Khlebnikov <khlebnikov@yandex-team.ru>, linux-fsdevel <linux-fsdevel@vger.kernel.org>, linux-kernel <linux-kernel@vger.kernel.org>, overlayfs <linux-unionfs@vger.kernel.org>, "stable [v4.8]" <stable@vger.kernel.org>

On Mon, Jul 24, 2017 at 10:15:22AM +0200, Miklos Szeredi wrote:
> On Sat, Jul 22, 2017 at 11:30 AM, Amir Goldstein <amir73il@gmail.com> wrote:
> > Bumped into this patch (Now upstream commit 51f8f3c4e225) and realized
> > it is missing cc: stable # v4.8
> >
> > At least this docker PR suggests that regression introduced in v4.8 will not be
> > appreciated down the road:
> > https://github.com/moby/moby/issues/29364
> 
> Greg,
> 
> Can you please queue 51f8f3c4e225 ("ovl: drop CAP_SYS_RESOURCE from
> saved mounter's credentials") for 4.9.y?

Now queued up, thanks.

greg k-h
