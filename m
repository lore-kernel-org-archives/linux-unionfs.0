From: Miklos Szeredi <miklos@szeredi.hu>
Subject: Re: [PATCH v2 01/18] overlay: implement fsck utility
Date: Fri, 15 Dec 2017 17:14:06 +0100
Message-ID: <CAJfpeguxMP7bRLFXsOm9tBP2MG-OT9LMxnyv8_0ksQnV=HhTQQ@mail.gmail.com>
References: <20171214064747.20999-1-yi.zhang@huawei.com> <20171214064747.20999-2-yi.zhang@huawei.com>
 <CAJfpegvCDyD3Zmc-h5hzkYRGC-cAn4myub3fwvqEVhRNse=yaw@mail.gmail.com>
 <CAOQ4uxh-4kKPLHDXHJux2_tM35frxxNWmPEZcDu2EQ2n+yYkKA@mail.gmail.com>
 <CAJfpegt7LR=G+UK5VY0kEScduuBj2SFhAw3pf1_8NSM+r61PeQ@mail.gmail.com>
 <CAOQ4uxg7UahQ=t2sWpf0FEi7MP+OT3XfO8AB_y+0qpeq8CWgrA@mail.gmail.com>
 <CAJfpegt-Upt3z4wFVQJ5bJf9pBbjOGXd93P+3LZdemSeS0Y_BA@mail.gmail.com>
 <CAOQ4uxg+DY=9MT+2sPNBnM77qv8eqyY5mCqnE6k1viptmLR8yA@mail.gmail.com>
 <CAJfpegsMT6ctTDRDQHosz52ZTg5gQgmxr5Em3YGm-htQzdNjCA@mail.gmail.com>
 <CAOQ4uxhU72XkzeTr19p5G+nGt9ONfb8=AxzqOBk-Sc2seR2fLw@mail.gmail.com>
 <CAJfpegsQvKfOLh2cWj496+g9pFFPmXbRdwZobqVDaQ_7-EBgrQ@mail.gmail.com>
 <CAOQ4uxgxwFjJH6hhxJDZP1vzBViTgPnur6GPuNaQmhhg+QjN1w@mail.gmail.com> <CAJfpegvSAiWYirK2729KP6vKm=A=tdTpg32K6JVTrV_aOdatxw@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Return-path: <linux-unionfs-owner@vger.kernel.org>
Received: from mail-qt0-f169.google.com ([209.85.216.169]:34301 "EHLO
        mail-qt0-f169.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S932359AbdLOQOI (ORCPT
        <rfc822;linux-unionfs@vger.kernel.org>);
        Fri, 15 Dec 2017 11:14:08 -0500
Received: by mail-qt0-f169.google.com with SMTP id 33so12718872qtv.1
        for <linux-unionfs@vger.kernel.org>; Fri, 15 Dec 2017 08:14:07 -0800 (PST)
In-Reply-To: <CAJfpegvSAiWYirK2729KP6vKm=A=tdTpg32K6JVTrV_aOdatxw@mail.gmail.com>
Sender: linux-unionfs-owner@vger.kernel.org
List-Id: linux-unionfs@vger.kernel.org
To: Amir Goldstein <amir73il@gmail.com>
Cc: "zhangyi (F)" <yi.zhang@huawei.com>, "linux-unionfs@vger.kernel.org" <linux-unionfs@vger.kernel.org>, fstests <fstests@vger.kernel.org>, Eryu Guan <eguan@redhat.com>, "Darrick J. Wong" <darrick.wong@oracle.com>, Miao Xie <miaoxie@huawei.com>, Vivek Goyal <vgoyal@redhat.com>

On Fri, Dec 15, 2017 at 5:06 PM, Miklos Szeredi <miklos@szeredi.hu> wrote:
> On Fri, Dec 15, 2017 at 3:44 PM, Amir Goldstein <amir73il@gmail.com> wrote:

>> OK, but I don't see how we can escape unpack tool for rebuilding the index
>> from redirects.

We can't.  But we can detect missing or broken index, which can prompt
the rebuilding.

>> Do you mean that you want to also follow non-dir "redirect"?

Only when necessary.

>> Resolve conflicts between "redirect" and "origin"?
>> Fix "redirect" by "origin"? fix "origin" by redirect"?

Interesting questions.  I'd guess "redirect" should be the
authoritative one normally, while in the snapshot case it's the other
way around.

Thanks,
Miklos
