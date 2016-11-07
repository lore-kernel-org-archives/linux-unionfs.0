From: Miklos Szeredi <miklos@szeredi.hu>
Subject: Re: [PATCH 3/3] ovl: redirect on rename-dir
Date: Mon, 7 Nov 2016 11:04:04 +0100
Message-ID: <CAJfpeguB-RRFbuwy=csPxoByKC=FTxYyuvnm+rmfTUmkVX+K9w@mail.gmail.com>
References: <1477380887-21333-1-git-send-email-mszeredi@redhat.com>
 <1477380887-21333-4-git-send-email-mszeredi@redhat.com> <20161025115748.ydhkkp5cfcdnjzwn@home.ouaza.com>
 <CAJfpegu97ce6LtMeKSHqDxZGAtCJUGgYUwOwYm9P6p8XtNXf_A@mail.gmail.com>
 <CALYGNiN_Hj+4Kf4HJihu5OEkNFU+zzioz5Cc1oHpJ8Wggi0M8Q@mail.gmail.com>
 <CAJfpegvzsjWBL5nu7SQt2kp7efjGMpb9L2JMxzXPXUTdDnft0Q@mail.gmail.com> <CALYGNiOfcuM55458mZoUd4r789z7nVs7Yj0vAA5Qo=BetTJA0Q@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Return-path: <linux-fsdevel-owner@vger.kernel.org>
In-Reply-To: <CALYGNiOfcuM55458mZoUd4r789z7nVs7Yj0vAA5Qo=BetTJA0Q@mail.gmail.com>
Sender: linux-fsdevel-owner@vger.kernel.org
To: Konstantin Khlebnikov <koct9i@gmail.com>
Cc: Raphael Hertzog <hertzog@debian.org>, Miklos Szeredi <mszeredi@redhat.com>, "linux-unionfs@vger.kernel.org" <linux-unionfs@vger.kernel.org>, Guillem Jover <guillem@debian.org>, linux-fsdevel <linux-fsdevel@vger.kernel.org>, Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
List-Id: linux-unionfs@vger.kernel.org

On Mon, Nov 7, 2016 at 10:58 AM, Konstantin Khlebnikov <koct9i@gmail.com> wrote:

> I've stumbled on somehow related problem - concurrent copy-ups are
> strictly serialized by rename locks.
> Obviously, file copying could be done in parallel: locks are required
> only for final rename.
> Because of that overlay slower that aufs for some workloads.

Easy to fix: for each copy up create a separate subdir of "work".
Then the contention is only for the time of creating the subdir, which
is very short.

Thanks,
Miklos
