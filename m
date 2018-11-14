Return-Path: <amir73il@gmail.com>
MIME-Version: 1.0
References: <20181027200450.GA5909@thunk.org> <CAJfpegtCYkXiSYtw4dWGc=Fj2U3GaWiOiub+JmZ8pRXHNk4ERQ@mail.gmail.com>
 <20181029220404.GB15839@thunk.org> <CAOQ4uxiu6iS-VuEtPhequVp7Ukx7Kh0FUpECSXfkaZN==o7sJw@mail.gmail.com>
In-Reply-To: <CAOQ4uxiu6iS-VuEtPhequVp7Ukx7Kh0FUpECSXfkaZN==o7sJw@mail.gmail.com>
From: Amir Goldstein <amir73il@gmail.com>
Date: Wed, 14 Nov 2018 11:46:59 +0200
Message-ID: <CAOQ4uxjsfgfo3rXtFKQk4A_fU2tvo38GFhzz7H9h1+R4trjd6Q@mail.gmail.com>
Subject: Re: overlayfs 4.19: unable to make backup link: Invalid cross-device link
Content-Type: text/plain; charset="UTF-8"
To: Miklos Szeredi <miklos@szeredi.hu>, Vivek Goyal <vgoyal@redhat.com>
Cc: overlayfs <linux-unionfs@vger.kernel.org>, linux-fsdevel <linux-fsdevel@vger.kernel.org>, =?UTF-8?Q?Maciej_Zi=C4=99ba?= <maciekz82@gmail.com>, Theodore Tso <tytso@mit.edu>
List-ID: <linux-unionfs@vger.kernel.org>

On Tue, Oct 30, 2018 at 6:44 AM Amir Goldstein <amir73il@gmail.com> wrote:
>
...
>
> So let's try to bisect the offending feature first.
> If we can't find an offending feature, then there may be an offending
> commit in 4.18..4.19
>
> With kernel 4.19, please try to reproduce after:
> echo N > /sys/module/overlay/parameters/metacopy
> and then after:

Miklos, Vivek,

FYI, Maciej has reported that he reproduced the same issue and that
disabling metacopy fixes the problem.

He offered to provide more information if requested.

Thanks,
Amir.
