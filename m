From: Linus Torvalds <torvalds@linux-foundation.org>
Subject: Re: [GIT PULL] overlayfs update for 4.9
Date: Thu, 13 Oct 2016 21:03:23 -0700
Message-ID: <CA+55aFyEtF-t5rbbOtAz1+Rdxcbbt+CTrWJWPg1+TViq+DoLCQ@mail.gmail.com>
References: <20161013143751.GE31239@veci.piliscsaba.szeredi.hu>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Return-path: <linux-fsdevel-owner@vger.kernel.org>
In-Reply-To: <20161013143751.GE31239@veci.piliscsaba.szeredi.hu>
Sender: linux-fsdevel-owner@vger.kernel.org
To: Miklos Szeredi <miklos@szeredi.hu>
Cc: Al Viro <viro@zeniv.linux.org.uk>, Linux Kernel Mailing List <linux-kernel@vger.kernel.org>, linux-fsdevel <linux-fsdevel@vger.kernel.org>, linux-unionfs@vger.kernel.org
List-Id: linux-unionfs@vger.kernel.org

On Thu, Oct 13, 2016 at 7:37 AM, Miklos Szeredi <miklos@szeredi.hu> wrote:
>
> Please pull from:

No.

Or rather, I pulled and then immediately unpulled. When I look at the
diff, I saw an obvious bug in the very first chunk. I'm not going to
pull something that is this obviously buggy and untested.

Your change to fs/ioctl.c to add a -EXDEV error case very clearly
leaks a reference to 'src_file'.

It's too late in the merge window for this to be fixed up any more.
This has been a painful enough merge window for me that I'm not going
to play around with obviously buggy pull requests.

                  Linus
