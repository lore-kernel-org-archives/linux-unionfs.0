From: Miklos Szeredi <miklos@szeredi.hu>
Subject: Re: [GIT PULL] overlayfs update for 4.14
Date: Thu, 14 Sep 2017 22:12:24 +0200
Message-ID: <CAJfpegvK_LyL0eHbmpp=NrJMnS1i8KkPpxRtBL_zyB_n-NKg7A@mail.gmail.com>
References: <20170913140528.GA19278@veci.piliscsaba.szeredi.hu>
 <CA+55aFzgQWNMc8Mx1SvCxt53wWJc67qB0uo95=VC1eivmG=YxA@mail.gmail.com>
 <CAJfpegtYjNyW1HnF2PAdmRWB4nq3eTF9O5-H2tnztZhagVW+Uw@mail.gmail.com> <CA+55aFzzKg17=RYTUomF9Fsy0mM5Acqkak0EZJPivZ5+oZErwA@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <CA+55aFzzKg17=RYTUomF9Fsy0mM5Acqkak0EZJPivZ5+oZErwA@mail.gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: Al Viro <viro@zeniv.linux.org.uk>, Linux Kernel Mailing List <linux-kernel@vger.kernel.org>, linux-fsdevel <linux-fsdevel@vger.kernel.org>, "linux-unionfs@vger.kernel.org" <linux-unionfs@vger.kernel.org>
List-Id: linux-unionfs@vger.kernel.org

On Thu, Sep 14, 2017 at 10:00 PM, Linus Torvalds
<torvalds@linux-foundation.org> wrote:
> If you can't bother to try to make it act as a proper VFS thing, then
> I don't want to see patches from you to the VFS code.

I was saying that it's a bad idea to mix external and internal flags.
That was the reason the two were separated on that API. I'm open to
arguments about that.

Thanks,
Miklos
