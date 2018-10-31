Return-Path: <vgoyal@redhat.com>
Date: Wed, 31 Oct 2018 10:05:41 -0400
From: Vivek Goyal <vgoyal@redhat.com>
Subject: Re: [PATCH v2] ovl: return error on mount if metacopy cannot be
 enabled
Message-ID: <20181031140541.GA22810@redhat.com>
References: <20181031111038.20570-1-amir73il@gmail.com>
 <CAJfpegvfRu3qFCnjho0aDEL22Fs6dHAK7p9FU9n=puQ1FbGjTQ@mail.gmail.com>
 <20181031121920.GF23439@veci.piliscsaba.redhat.com>
 <CAOQ4uxhNPFfytQtiQ3U394i_kj609of7sG_AN9nOyjkd4keKDg@mail.gmail.com>
 <CAJfpegux1jxgFbDhxsE_+u9_L_JgohFkf7K8in-p+B187iDJdQ@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CAJfpegux1jxgFbDhxsE_+u9_L_JgohFkf7K8in-p+B187iDJdQ@mail.gmail.com>
To: Miklos Szeredi <miklos@szeredi.hu>
Cc: Amir Goldstein <amir73il@gmail.com>, overlayfs <linux-unionfs@vger.kernel.org>
List-ID: <linux-unionfs@vger.kernel.org>

On Wed, Oct 31, 2018 at 01:35:38PM +0100, Miklos Szeredi wrote:
> On Wed, Oct 31, 2018 at 1:26 PM, Amir Goldstein <amir73il@gmail.com> wrote:
> > On Wed, Oct 31, 2018 at 2:19 PM Miklos Szeredi <miklos@szeredi.hu> wrote:
> 
> > My 'strict' patch did not try to deal with implicitly enabling redirect_dir
> > Vivek posted a different patch to deal with that.
> 
> What I mean, is that sections of your patch dealing with the
> redirect_dir conflict and sections of Vivek's patch dealing with
> _enforce are completely unnecessary if we just define the rules of
> implicit enable/disable between metacopy and redirect_dir.
> 
> >>                         config->redirect_mode = match_strdup(&args[0]);
> >>                         if (!config->redirect_mode)
> >>                                 return -ENOMEM;
> >> +
> >> +                       /* "redirect_dir=off" implies "metacopy=off" */
> >> +                       if (strcmp(config->redirect_mode, "off") == 0 ||
> >> +                           strcmp(config->redirect_mode, "nofollow") == 0)
> >> +                               config->metacopy = false;
> >
> > This look completely counter to the 'strict' behavior definition.
> > If user specified metacopy=on, we are not allowed to end up with metacopy=off.
> 
> What about "metacopy=on,metacopy=off"?

I would think that ordering will matter. metacopy=off will override,
metacopy=on (because its later in the order).

> 
> What I'm saying is that "metacopy=on,redirect_dir=off" should be
> exactly equivalent to the above, if taking the implicit disable rule
> into account.

I am wondering why do we have to accept nonsense options possibilities.
Why not simply reject them with -EINVAL. IMHO, that behavior is much
simpler to deal with than implicitly disabling metacopy because
redirect_dir=off.

If some options don't make sense together, then it makes sense to return
error and let user understand it and fix it. 

Thanks
Vivek
