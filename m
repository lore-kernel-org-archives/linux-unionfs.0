Return-Path: <richard@nod.at>
From: Richard Weinberger <richard@nod.at>
Subject: Re: [EXTERNAL] Re: Copy_up function fail with ubifs on upper layer
Date: Tue, 11 Dec 2018 10:54:21 +0100
Message-ID: <18631278.YDA9SCgu4D@blindfold>
In-Reply-To: <CAOQ4uxip5zOUWwg4j3kWuQMPe83F=bwrtHQK0BfmQE=AGm8=5w@mail.gmail.com>
References: <D10F1B1F86300941BC976D07C04B3AA0016E4CC7@LOUTCSMB11.napa.ad.etn.com> <D10F1B1F86300941BC976D07C04B3AA0016E5E59@LOUTCSMB11.napa.ad.etn.com> <CAOQ4uxip5zOUWwg4j3kWuQMPe83F=bwrtHQK0BfmQE=AGm8=5w@mail.gmail.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 7Bit
Content-Type: text/plain; charset="us-ascii"
To: Amir Goldstein <amir73il@gmail.com>
Cc: VincentGuerard@eaton.com, Miklos Szeredi <miklos@szeredi.hu>, overlayfs <linux-unionfs@vger.kernel.org>
List-ID: <linux-unionfs@vger.kernel.org>

Am Montag, 10. Dezember 2018, 21:37:46 CET schrieb Amir Goldstein:
> On Mon, Dec 10, 2018 at 10:02 PM Guerard, Vincent
> <VincentGuerard@eaton.com> wrote:
> >
> > Here's the output when overlayfs try to do a copy up with the original function calls order and with debug enabled:
> >
> > root@io2200:/etc# mv machine-id machine-id1
> > mv: cannot move 'machine-id' to 'machine-id1': No such file or directory
> > root@io2200:/etc# dmesg
> > [ 2999.275275] tmpfile(upper.work/work, 0100644) = 0
> > [ 2999.278789] setxattr(work/#232, "trusted.overlay.origin", "(null)", 0x0) = -2
> >
> > And here's with inverted function calls:
> > root@io2200:/etc# mv securetty securetty1
> > root@io2200:/etc# dmesg
> > [  659.515200] tmpfile(upper.work/work, 0100400) = 0
> > [  659.515422] link(work/#164, etc/securetty) = 0
> > [  659.518577] setxattr(work/#164, "trusted.overlay.origin", "(null)", 0x0) = 0
> > [  659.522153] rename(etc/securetty, etc/securetty1, 0x4)
> >
> 
> Maybe this is the patch you need:
> https://marc.info/?l=linux-unionfs&m=154070087430992&w=2

Hmm, this fixes something different.
Vincent, do you trigger this every time or just once?
Is a power-cut involved?

Long story short, I need more info.

Thanks,
//richard
