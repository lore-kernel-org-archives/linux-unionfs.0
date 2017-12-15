From: Vivek Goyal <vgoyal@redhat.com>
Subject: Re: [PATCH v2 01/18] overlay: implement fsck utility
Date: Fri, 15 Dec 2017 10:16:44 -0500
Message-ID: <20171215151644.GA6427@redhat.com>
References: <20171214064747.20999-2-yi.zhang@huawei.com>
 <CAJfpegvCDyD3Zmc-h5hzkYRGC-cAn4myub3fwvqEVhRNse=yaw@mail.gmail.com>
 <CAOQ4uxh-4kKPLHDXHJux2_tM35frxxNWmPEZcDu2EQ2n+yYkKA@mail.gmail.com>
 <CAJfpegt7LR=G+UK5VY0kEScduuBj2SFhAw3pf1_8NSM+r61PeQ@mail.gmail.com>
 <CAOQ4uxg7UahQ=t2sWpf0FEi7MP+OT3XfO8AB_y+0qpeq8CWgrA@mail.gmail.com>
 <CAJfpegt-Upt3z4wFVQJ5bJf9pBbjOGXd93P+3LZdemSeS0Y_BA@mail.gmail.com>
 <CAOQ4uxg+DY=9MT+2sPNBnM77qv8eqyY5mCqnE6k1viptmLR8yA@mail.gmail.com>
 <CAJfpegsMT6ctTDRDQHosz52ZTg5gQgmxr5Em3YGm-htQzdNjCA@mail.gmail.com>
 <CAOQ4uxhU72XkzeTr19p5G+nGt9ONfb8=AxzqOBk-Sc2seR2fLw@mail.gmail.com>
 <CAJfpegsQvKfOLh2cWj496+g9pFFPmXbRdwZobqVDaQ_7-EBgrQ@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-unionfs-owner@vger.kernel.org>
Received: from mx1.redhat.com ([209.132.183.28]:36274 "EHLO mx1.redhat.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1756692AbdLOPQp (ORCPT <rfc822;linux-unionfs@vger.kernel.org>);
        Fri, 15 Dec 2017 10:16:45 -0500
Content-Disposition: inline
In-Reply-To: <CAJfpegsQvKfOLh2cWj496+g9pFFPmXbRdwZobqVDaQ_7-EBgrQ@mail.gmail.com>
Sender: linux-unionfs-owner@vger.kernel.org
List-Id: linux-unionfs@vger.kernel.org
To: Miklos Szeredi <miklos@szeredi.hu>
Cc: Amir Goldstein <amir73il@gmail.com>, "zhangyi (F)" <yi.zhang@huawei.com>, "linux-unionfs@vger.kernel.org" <linux-unionfs@vger.kernel.org>, fstests <fstests@vger.kernel.org>, Eryu Guan <eguan@redhat.com>, "Darrick J. Wong" <darrick.wong@oracle.com>, Miao Xie <miaoxie@huawei.com>

On Fri, Dec 15, 2017 at 03:18:58PM +0100, Miklos Szeredi wrote:
> On Thu, Dec 14, 2017 at 5:29 PM, Amir Goldstein <amir73il@gmail.com> wrote:
> > On Thu, Dec 14, 2017 at 5:48 PM, Miklos Szeredi <miklos@szeredi.hu> wrote:
> >> On Thu, Dec 14, 2017 at 4:18 PM, Amir Goldstein <amir73il@gmail.com> wrote:
> >>> On Thu, Dec 14, 2017 at 5:10 PM, Miklos Szeredi <miklos@szeredi.hu> wrote:
> > [...]
> >>> Yes :) Docker uses tar alright.
> >>> But for example "origin" xattr cannot be exported as is to a portable format.
> >>> Need to decode file handles during export and change them to "redirect"
> >>> for directories and possible to "redirect" for files as well, that
> >>> would be converted
> >>> back to "origin" on import.
> >>
> >> Is it worth preserving origin for non-hardlinks?  Same story as "cp
> >> -a", inode numbers will change, so there doesn't appear to be a reason
> >> to preserve the connection between origin and the copied up file.
> >
> > Besides metacopy, no reason.
> >
> >>
> >>> Exporting index is a challenge for the same reason and also because tar can
> >>> break hardlinks on extract. Probably index should be rebuilt from scratch on
> >>> import, based on "redirect".
> >>
> >> Yes, hard links need special handling, so will metacopy.  Might be
> >> worth adding "redirect" to hard links and metacopy to make this issue
> >> less of a problem.
> >>
> >
> > Do you mean add it now in kernel? hmm, that's just another thing that
> > can become inconsistent, so I don't see the immediate value.
> 
> The immediate value is that no need for a special pack/unpack tool for
> transferring the overlay "image".

Hi Miklos,

So idea is that I should use use REDIRECT xattr instead of ORIGIN for
metacopy. I guess it should work for atleast metacopy feature. Just
that order of lower dirs during mount will not be detected and IIUC,
we might end up doing a copy up of wrong file.

Vivek
