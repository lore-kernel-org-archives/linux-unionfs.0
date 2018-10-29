MIME-Version: 1.0
In-Reply-To: <20181027200450.GA5909@thunk.org>
References: <20181027200450.GA5909@thunk.org>
Date: Mon, 29 Oct 2018 09:31:58 +0100
Message-ID: <CAJfpegtCYkXiSYtw4dWGc=Fj2U3GaWiOiub+JmZ8pRXHNk4ERQ@mail.gmail.com>
Subject: Re: overlayfs 4.19: unable to make backup link: Invalid cross-device link
From: Miklos Szeredi <miklos@szeredi.hu>
Content-Type: text/plain; charset="UTF-8"
To: "Theodore Y. Ts'o" <tytso@mit.edu>
Cc: overlayfs <linux-unionfs@vger.kernel.org>, linux-fsdevel@vger.kernel.org
List-ID: <linux-unionfs@vger.kernel.org>

On Sat, Oct 27, 2018 at 10:04 PM, Theodore Y. Ts'o <tytso@mit.edu> wrote:
> I was rebuilding my dropbox Docker container, and it failed in 4.19
> with the following error:
>
> dpkg: error processing archive /var/cache/apt/archives/perl-base_5.20.2-3+deb8u11_amd64.deb (--unpack):
>  unable to make backup link of `./usr/bin/perl5.20.2' before installing new version: Invalid cross-device link
> dpkg-deb: error: subprocess paste was killed by signal (Broken pipe)
> dpkg: error: error creating new backup file '/var/lib/dpkg/status-old': Invalid cross-device link
> E: Sub-process /usr/bin/dpkg returned an error code (2)
>
> When I booted the 4.18.0-2 kernel from Debian, the exact same Docker
> file worked just fine.  With 4.19 it fails reliably.

Can you please post

  grep OVERLAY_FS .config

?

I'd suspect METACOPY being enabled and regressing (since it's a new feature).

Thanks,
Mikos
