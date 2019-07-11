From: Greg KH <gregkh@linuxfoundation.org>
Subject: Re: overlayfs regression in master and stable trees
Date: Thu, 11 Jul 2019 17:41:10 +0200
Message-ID: <20190711154110.GA28220@kroah.com>
References: <1560073529193139@kroah.com>
 <CAOQ4uxiTrsOs3KWOxedZicXNMJJharmWo=TDXDnxSC1XMNVKBg@mail.gmail.com>
 <CAOQ4uxiTTuOESvZ2Y5cSebqKs+qeU3q6ZMReBDro0Qv7aRBhpw@mail.gmail.com>
 <20190623010345.GJ2226@sasha-vm>
 <CAOQ4uxgv_FOLagfAMa=XLZZXnVhKoQK9oUHXiO45TZrKq5LQDw@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <stable-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <CAOQ4uxgv_FOLagfAMa=XLZZXnVhKoQK9oUHXiO45TZrKq5LQDw@mail.gmail.com>
Sender: stable-owner@vger.kernel.org
To: Amir Goldstein <amir73il@gmail.com>
Cc: Sasha Levin <sashal@kernel.org>, Miklos Szeredi <mszeredi@redhat.com>, stable <stable@vger.kernel.org>, overlayfs <linux-unionfs@vger.kernel.org>, Vivek Goyal <vgoyal@redhat.com>
List-Id: linux-unionfs@vger.kernel.org

On Thu, Jul 11, 2019 at 05:14:48PM +0300, Amir Goldstein wrote:
> >
> > >3) Disallow bogus layer combinations.
> > >syzbot has started to produce repros that create bogus layer combinations.
> > >So far it has only been able to reproduce a WARN_ON, which has already
> > >been fixed in stable, by  acf3062a7e1c ("ovl: relax WARN_ON()..."), but
> > >other real bugs could be lurking if those setups are allowed.
> > >We decided to detect and error on these setups on mount, to stop syzbot
> > >(and attackers) from trying to attack overlayfs this way.
> > >To stop syzbot from mutating this class of repros on stable kernel you
> > >MAY apply these 3 patches, but in any case, I would wait a while to see
> > >if more bugs are reported on master.
> > >Although this solves a problem dating before 4.19, I have no plans
> > >of backporting these patches further back.
> > >
> > >146d62e5a586 ovl: detect overlapping layers
> > >9179c21dc6ed ovl: don't fail with disconnected lower NFS
> > >1dac6f5b0ed2 ovl: fix bogus -Wmaybe-unitialized warning
> >
> > I've queued these 3 for 4.19.
> >
> 
> FYI, an overlayfs regression has been reported:
> https://github.com/containers/libpod/issues/3540
> 
> Caused by commit "ovl: detect overlapping layers"
> 
> I am working on a fix.
> In retrospect, given my lengthy disclaimer above, it seems
> that this patch should not have been applied to stable (yet).
> I believe that this patch belongs to a class of fixed that
> should soak in master for a while before being considered for
> stable. On my part, I will not propose these sort of fixed in the future,
> with or without a disclaimer until they have soaked in master.

That's fair enough, send the git ids to stable@vger when you feel they
have "soaked" long enough in the future.

thanks,

greg k-h
