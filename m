Return-Path: <amir73il@gmail.com>
MIME-Version: 1.0
References: <20181207121027.GA5996@dnyarri> <CAJfpegsu6DUHVVac2PSyGoFW4pAKm3UH0XLg5+SMvN5XZmNzFw@mail.gmail.com>
 <20190202172914.GA17406@dnyarri> <CAOQ4uxh0L_u-UzJAcQ=QO+D-9VkoSy2HHofXig4=AqDo0vWTmg@mail.gmail.com>
 <20190203101340.GA6934@dnyarri> <CAOQ4uxhBbAX5QizTAaBaSeUUmtOewzFcqb+RpxDxaz_5P5d7fQ@mail.gmail.com>
 <20190314010928.GA748@dnyarri> <CAOQ4uxg_zS8XBTaDqdUKxRvzntF-_Pq=vqk1sYJGfhaPKsJRLA@mail.gmail.com>
 <20190314103757.GA4654@dnyarri>
In-Reply-To: <20190314103757.GA4654@dnyarri>
From: Amir Goldstein <amir73il@gmail.com>
Date: Thu, 14 Mar 2019 21:38:05 +0200
Message-ID: <CAOQ4uxipOHT+OzPtFE1ZoSFEJSrEr-MErwp5KX+tBwXq39sx8g@mail.gmail.com>
Subject: Re: Failure to execute file on overlayfs during switch_root/chroot
Content-Type: text/plain; charset="UTF-8"
To: aszlig <aszlig@nix.build>
Cc: Miklos Szeredi <miklos@szeredi.hu>, overlayfs <linux-unionfs@vger.kernel.org>, Graham Christensen <graham@grahamc.com>, Samuel Dionne-Riel <samuel@dionne-riel.com>, michael bishop <cleverca22@gmail.com>
List-ID: <linux-unionfs@vger.kernel.org>

On Thu, Mar 14, 2019 at 12:41 PM aszlig <aszlig@nix.build> wrote:
>
> On Thu, Mar 14, 2019 at 09:47:23AM +0200, Amir Goldstein wrote:
> > Overlayfs is not expected to modify the lower layer.
>
> That is pretty clear, I mean that's the whole point of overlayfs, right? :-)
>
> > OTOH, I can't really think anything that should break horribly if
> > we allow overlayfs to update atime on a writable lower layer??
>
> It wasn't using O_NOATIME prior to Linux 4.19 (which is where this was starting
> to break our tooling), but the bisected commit I mentioned initially
> (a6518f73e60e5044656d1ba587e7463479a9381a) was (implicitly) introducing
> O_NOATIME, so to the contrary I'd say it would actually un-break networking
> file systems with overlayfs.
>

Hmm, pre 4.19 was different, but it's true, I think that lower open files
did not have O_NOATIME AFAIK.
OTOH, ovl_path_open() from ovl_copy_up_data() does open lower
file with O_NOATIME, so I am a bit surprised you did not see the
same issue there. I suppose the answer will require another dive...

Thanks,
Amir.
