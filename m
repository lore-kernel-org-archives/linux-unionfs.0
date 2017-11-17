From: Linus Torvalds <torvalds@linux-foundation.org>
Subject: Re: [GIT PULL] overlayfs update for 4.15
Date: Fri, 17 Nov 2017 13:49:01 -0800
Message-ID: <CA+55aFxPPXo1UD_4kuSamJYx1FbcpVFx3ANzfxJpFKVhd_gROQ@mail.gmail.com>
References: <20171117151317.GA5348@veci.piliscsaba.szeredi.hu>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <20171117151317.GA5348@veci.piliscsaba.szeredi.hu>
Sender: linux-kernel-owner@vger.kernel.org
To: Miklos Szeredi <miklos@szeredi.hu>
Cc: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>, linux-fsdevel <linux-fsdevel@vger.kernel.org>, linux-unionfs@vger.kernel.org
List-Id: linux-unionfs@vger.kernel.org

On Fri, Nov 17, 2017 at 7:13 AM, Miklos Szeredi <miklos@szeredi.hu> wrote:
>
> Created a path_put_init() helper that clears out the pointers after putting the
> ref.  I think this could be useful elsewhere, so added it to <linux/path.h>.

Slight eww.

The problem with your helper is that we've seen gcc generate really
horrible code for things like that.

So when you do

     *path = (struct path) { };

we've seen gcc first create an local empty "struct path" on stack, and
then memcpy() it over the target. Which is _technically_ what that
code does, of course, but it's also excessively stupid.

So I suspect that would be better off as just

     memset(path, 0, sizeof(*path));

which then matches the code that you actually would expect gcc to generate.

I hope that "struct path" is small enough that gcc doesn't mess up,
and that odd code generation is probably specific to some gcc versions
anyway, but we've definitely seen this.

NOTE! The above pattern of assignment is very different from the
initialization pattern. Gcc generally does well on structure
initializers:

    struct xyz a = { .. };

generally generates reasonable code in ways that

    struct xyz a;
    ..
    a = (struct xyz) { ...};

sometimes doesn't.  I suspect it's mainly a "initializers are common,
unnamed temporary local structures are not" thing.

                  Linus
