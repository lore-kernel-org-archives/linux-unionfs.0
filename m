From: Geert Uytterhoeven <geert@linux-m68k.org>
Subject: Re: [GIT PULL] overlay filesystem v25
Date: Fri, 24 Oct 2014 09:28:20 +0200
Message-ID: <CAMuHMdXiR7WjjR0T=W3kQShykSsiF0kKMfz75+BNbB=xHvkC0w@mail.gmail.com>
References: <20141023232539.GA4662@tucsk.piliscsaba.szeredi.hu>
	<20141024022055.GH7996@ZenIV.linux.org.uk>
	<20141024032422.GI7996@ZenIV.linux.org.uk>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <20141024032422.GI7996@ZenIV.linux.org.uk>
Sender: linux-kernel-owner@vger.kernel.org
To: Al Viro <viro@zeniv.linux.org.uk>
Cc: Linus Torvalds <torvalds@linux-foundation.org>, Miklos Szeredi <miklos@szeredi.hu>, Linux FS Devel <linux-fsdevel@vger.kernel.org>, "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>, linux-unionfs@vger.kernel.org, Stephen Rothwell <sfr@canb.auug.org.au>
List-Id: linux-unionfs@vger.kernel.org

Hi Al,

On Fri, Oct 24, 2014 at 5:24 AM, Al Viro <viro@zeniv.linux.org.uk> wrote:
> On Fri, Oct 24, 2014 at 03:20:55AM +0100, Al Viro wrote:
>> Why the hell do you hold ->i_mutex across the entire opening of underlying
>> directory?  All you need is to serialize one assignment; the side that loses
>> the race will simply fput() what it opened...
>>
>> Oh, well - that goes under "weird pessimisations, easy to fix in followups"...
>
> OK, pulled into vfs.git, followups in question added.  Also there: fix for
> a long-standing leak in d_splice_alias() failure exits.  Guys, could you
> check that current vfs.git#for-linus survives your local tests?  Seems to
> survive here; if I don't hear of any problems by tomorrow morning, to Linus
> it goes...  FWIW, for that pull request stats would be

I think you forgot to merge your for-linus branch into for-next?

Anyway, as Stephen announced there will be no linux-next release
today, I'm afraid you'll have to delay your pull request to Tuesday.

Gr{oetje,eeting}s,

                        Geert

--
Geert Uytterhoeven -- There's lots of Linux beyond ia32 -- geert@linux-m68k.org

In personal conversations with technical people, I call myself a hacker. But
when I'm talking to journalists I just say "programmer" or something like that.
                                -- Linus Torvalds
