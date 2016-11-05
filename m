From: Peter Rosin <peda@axentia.se>
Subject: Re: [GIT PULL] overlayfs fixes for 4.9-rc3
Date: Sat, 5 Nov 2016 22:41:16 +0100
Message-ID: <b3447494-eb16-ba51-c86a-22718f3e9b48@axentia.se>
References: <CAJfpegs6e_K7y-CPj4dm1qtoF6h1z0dFrXHxJSc8TsV=ckuEbA@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <CAJfpegs6e_K7y-CPj4dm1qtoF6h1z0dFrXHxJSc8TsV=ckuEbA@mail.gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
To: Miklos Szerendi <miklos@szeredi.hu>
Cc: linux-kernel@vger.kernel.org, linux-fsdevel@vger.kernel.org, linux-unionfs@vger.kernel.org, Linus Torvalds <torvalds@linux-foundation.org>, Amir Goldstein <amir73il@gmail.com>
List-Id: linux-unionfs@vger.kernel.org

> And the thing is, backward incompatibility is less of an issue for
> overlayfs than for normal filesystems, because it's usually not
> something people store their root filesystems on, and if so they can
> simply not turn off this feature.

That got my attention. What backwards incompatible thing is it that
I simply cannot turn off for the overlayfs that I use as root fs?
Now, we don't boot straight into the overlay as root fs, buy we do
pivot it in early enough. If you are somehow suggesting that
overlayfs as root fs is not something that needs considering you
need to think again. We depend on it, and I will flag any regression
that we are walking into.

But hopefully you just messed up the negations, and you meant that we
*can* simply turn <whatever> off?

Cheers,
Peter

[I hope threading works, got the message-id from an archive]
