Return-Path: <amir73il@gmail.com>
MIME-Version: 1.0
References: <20181031111038.20570-1-amir73il@gmail.com> <CAJfpegvfRu3qFCnjho0aDEL22Fs6dHAK7p9FU9n=puQ1FbGjTQ@mail.gmail.com>
 <20181031121920.GF23439@veci.piliscsaba.redhat.com> <CAOQ4uxhNPFfytQtiQ3U394i_kj609of7sG_AN9nOyjkd4keKDg@mail.gmail.com>
 <CAJfpegux1jxgFbDhxsE_+u9_L_JgohFkf7K8in-p+B187iDJdQ@mail.gmail.com> <CAJfpegsePKZnNe_5OV4D-Y23Ui3_MAytf-rYEFxXwxypfpuzdg@mail.gmail.com>
In-Reply-To: <CAJfpegsePKZnNe_5OV4D-Y23Ui3_MAytf-rYEFxXwxypfpuzdg@mail.gmail.com>
From: Amir Goldstein <amir73il@gmail.com>
Date: Wed, 31 Oct 2018 15:42:54 +0200
Message-ID: <CAOQ4uxgymAHZTHdh6AfEF5Sv49mtg5TbFNx6=RBdPFNrZG8m3w@mail.gmail.com>
Subject: Re: [PATCH v2] ovl: return error on mount if metacopy cannot be enabled
Content-Type: text/plain; charset="UTF-8"
To: Miklos Szeredi <miklos@szeredi.hu>
Cc: Vivek Goyal <vgoyal@redhat.com>, overlayfs <linux-unionfs@vger.kernel.org>
List-ID: <linux-unionfs@vger.kernel.org>

On Wed, Oct 31, 2018 at 2:37 PM Miklos Szeredi <miklos@szeredi.hu> wrote:
>
> On Wed, Oct 31, 2018 at 1:35 PM, Miklos Szeredi <miklos@szeredi.hu> wrote:
>
> >>>                         config->redirect_mode = match_strdup(&args[0]);
> >>>                         if (!config->redirect_mode)
> >>>                                 return -ENOMEM;
> >>> +
> >>> +                       /* "redirect_dir=off" implies "metacopy=off" */
> >>> +                       if (strcmp(config->redirect_mode, "off") == 0 ||
> >>> +                           strcmp(config->redirect_mode, "nofollow") == 0)
> >>> +                               config->metacopy = false;
> >>
> >> This look completely counter to the 'strict' behavior definition.
> >> If user specified metacopy=on, we are not allowed to end up with metacopy=off.
> >
> > What about "metacopy=on,metacopy=off"?
> >
> > What I'm saying is that "metacopy=on,redirect_dir=off" should be
> > exactly equivalent to the above, if taking the implicit disable rule
> > into account.
>
> In other words: it's a nonsense combination of options, just like the
> former.  If documented, then I don't think this would cause problems.
>

I see. That makes sense.
Both metacopy and redirect_dir depend only on upper xattr
which makes this easy.
Although the dependency check of redirect_dir->xattr is missing
so I will look at adding that too.

Will post v2 of 'strict' series later today, with or without your
suggestion about changing inter feature relationship.
Either solution will be sufficient or Vivek can take it from there.

Thanks,
Amir.
