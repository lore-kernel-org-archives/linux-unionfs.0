From: Vivek Goyal <vgoyal@redhat.com>
Subject: Re: [PATCH 3/8] ovl: Provide a mount option metacopy=on/off for
 metadata copyup
Date: Mon, 9 Oct 2017 10:53:59 -0400
Message-ID: <20171009145359.GA2485@redhat.com>
References: <1507312037-30909-1-git-send-email-vgoyal@redhat.com>
 <1507312037-30909-4-git-send-email-vgoyal@redhat.com>
 <CAOQ4uxiP+QjNW7P1n0-wK-PEVUYCZR_gLd3_H_ZbhC=B5fQvmg@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-unionfs-owner@vger.kernel.org>
Received: from mx1.redhat.com ([209.132.183.28]:62049 "EHLO mx1.redhat.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1754509AbdJIOyA (ORCPT <rfc822;linux-unionfs@vger.kernel.org>);
        Mon, 9 Oct 2017 10:54:00 -0400
Content-Disposition: inline
In-Reply-To: <CAOQ4uxiP+QjNW7P1n0-wK-PEVUYCZR_gLd3_H_ZbhC=B5fQvmg@mail.gmail.com>
Sender: linux-unionfs-owner@vger.kernel.org
List-Id: linux-unionfs@vger.kernel.org
To: Amir Goldstein <amir73il@gmail.com>
Cc: overlayfs <linux-unionfs@vger.kernel.org>, Miklos Szeredi <miklos@szeredi.hu>

On Fri, Oct 06, 2017 at 10:01:47PM +0300, Amir Goldstein wrote:

[..]
> > @@ -441,6 +461,12 @@ static int ovl_parse_opt(char *opt, struct ovl_config *config)
> >                 config->workdir = NULL;
> >         }
> >
> > +       /* As of now metacopy=on is dependent on index=on */
> > +       if (config->metacopy && !config->index) {
> > +               pr_warn("overlayfs: can not enable metadata only copyup with index=off. Falling back to metacopy=off\n");
> > +               config->metacopy = false;
> > +       }
> > +
> 
> There are later places in fill_super where index may be falling back to off
> due to missing file handle support in lower fs.
> Please move this check to much later to make sure metacopy=on and index=off
> cannot co-exists.

Sure, I missed that. Will fix it.

Vivek
