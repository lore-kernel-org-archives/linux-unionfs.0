From: Amir Goldstein <amir73il@gmail.com>
Subject: Re: FAILED: patch "[PATCH] ovl: support the FS_IOC_FS[SG]ETXATTR
 ioctls" failed to apply to 5.1-stable tree
Date: Wed, 24 Jul 2019 16:46:36 +0300
Message-ID: <CAOQ4uxiEVsBp6qojO9K1TqzpETtdqDPzqTaFQGjr8woJ2WQP=g@mail.gmail.com>
References: <1560073529193139@kroah.com> <CAOQ4uxiTrsOs3KWOxedZicXNMJJharmWo=TDXDnxSC1XMNVKBg@mail.gmail.com>
 <CAOQ4uxiTTuOESvZ2Y5cSebqKs+qeU3q6ZMReBDro0Qv7aRBhpw@mail.gmail.com>
 <20190623010345.GJ2226@sasha-vm> <20190623202916.GA10957@kroah.com>
 <20190624003409.GO2226@sasha-vm> <CAOQ4uxiz5CkGojr5yquUd__TS_eae+ZapqyGaojiOUGniFPMsg@mail.gmail.com>
 <20190724115714.GA3244@kroah.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Return-path: <stable-owner@vger.kernel.org>
In-Reply-To: <20190724115714.GA3244@kroah.com>
Sender: stable-owner@vger.kernel.org
To: Greg KH <gregkh@linuxfoundation.org>
Cc: Sasha Levin <sashal@kernel.org>, Miklos Szeredi <mszeredi@redhat.com>, stable <stable@vger.kernel.org>, overlayfs <linux-unionfs@vger.kernel.org>
List-Id: linux-unionfs@vger.kernel.org

> > I don't think syzkaller ones are more relevant to 5.1 then the rest of
> > the patches applied to 4.19. If anything, its the other way around.
> > According to syzbot dashboard, it is being run on LTS kernels, not on
> > latest stable.
> >
> > Please forgive me if my language caused confusion, when I said
> > "please apply to 4.19" I meant 4.19+.
>
> So is anything else needed to be done here, or are we all caught up and
> everything merged properly?
>

All the needed patches have been merged, but
Upstream commit 146d62e5a5867fbf84490d82455718bfb10fe824
("ovl: detect overlapping layers") did introduce a regression to
docker and friends into stable kernels :-/

The fix commit is already tested and waiting in linux-next:
0be0bfd2de9d ("ovl: fix regression caused by overlapping layers detection")
but did not hit upstream yet. When it does, will need to apply it to v4.19+

Thanks,
Amir.
