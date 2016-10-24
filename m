From: Miklos Szeredi <miklos@szeredi.hu>
Subject: Re: [POC/RFC PATCH] overlayfs: fix data inconsistency at copy up
Date: Mon, 24 Oct 2016 10:11:56 +0200
Message-ID: <CAJfpegvSSbEzgFhAKi9QapZaa7exthzpys4N6QtPCATk8CzUEA@mail.gmail.com>
References: <20161012133326.GD31239@veci.piliscsaba.szeredi.hu>
 <20161020204630.GA1000@redhat.com> <20161020205408.GB1000@redhat.com>
 <CAOQ4uxh7cfh5ZtNX8hkeTuye6hRxbMpzZ4p9mGAn2z5rq3RGvA@mail.gmail.com>
 <20161021201335.GB20129@redhat.com> <CAOQ4uxiH6-JQcwSqvBcSaVzm5V5iyo4V5DWSxc1LH3aZPAvBEA@mail.gmail.com>
 <CAOQ4uxjzdhfC06gNmNNWweQ=r28TvK36Synt+jvPd2HM+wLTOw@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Return-path: <linux-fsdevel-owner@vger.kernel.org>
In-Reply-To: <CAOQ4uxjzdhfC06gNmNNWweQ=r28TvK36Synt+jvPd2HM+wLTOw@mail.gmail.com>
Sender: linux-fsdevel-owner@vger.kernel.org
To: Amir Goldstein <amir73il@gmail.com>
Cc: Vivek Goyal <vgoyal@redhat.com>, "linux-unionfs@vger.kernel.org" <linux-unionfs@vger.kernel.org>, linux-fsdevel <linux-fsdevel@vger.kernel.org>, linux-kernel <linux-kernel@vger.kernel.org>, Jeremy Eder <jeder@redhat.com>, David Howells <dhowells@redhat.com>, Gou Rao <grao@portworx.com>, Vinod Jayaraman <jv@portworx.com>, Al Viro <viro@zeniv.linux.org.uk>, Dave Chinner <david@fromorbit.com>
List-Id: linux-unionfs@vger.kernel.org

On Sat, Oct 22, 2016 at 5:39 PM, Amir Goldstein <amir73il@gmail.com> wrote:
> On Sat, Oct 22, 2016 at 10:24 AM, Amir Goldstein <amir73il@gmail.com> wrote:
>> On Fri, Oct 21, 2016 at 11:13 PM, Vivek Goyal <vgoyal@redhat.com> wrote:

>>> ---
>>>  fs/file.c            |   41 +++++++++++++++++++++++++++++++++++++++++
>>>  fs/overlayfs/inode.c |    1 +
>>>  2 files changed, 42 insertions(+)
>>>
>>> Index: rhvgoyal-linux/fs/overlayfs/inode.c
>>> ===================================================================
>>> --- rhvgoyal-linux.orig/fs/overlayfs/inode.c    2016-10-21 15:43:05.391488406 -0400
>>> +++ rhvgoyal-linux/fs/overlayfs/inode.c 2016-10-21 16:07:57.409420795 -0400
>>> @@ -416,6 +416,7 @@ static ssize_t ovl_read_iter(struct kioc
>>>                 if (IS_ERR(upperfile)) {
>>>                         ret = PTR_ERR(upperfile);
>>>                 } else {
>>> +                       replace_file(file, upperfile);

I think it's a cool idea.  But I'm not even going to look at the
implementation for now, because it's such a rare corner case, that
trying to optimize it should really be the last thing we do after
everything else is working fine (and only if it actually turns out to
be a thing that somebody actually cares about).

Thanks,
Miklos
