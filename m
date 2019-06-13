From: Amir Goldstein <amir73il@gmail.com>
Subject: Re: FAILED: patch "[PATCH] ovl: support the FS_IOC_FS[SG]ETXATTR
 ioctls" failed to apply to 5.1-stable tree
Date: Thu, 13 Jun 2019 11:49:03 +0300
Message-ID: <CAOQ4uxiTrsOs3KWOxedZicXNMJJharmWo=TDXDnxSC1XMNVKBg@mail.gmail.com>
References: <1560073529193139@kroah.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Return-path: <stable-owner@vger.kernel.org>
In-Reply-To: <1560073529193139@kroah.com>
Sender: stable-owner@vger.kernel.org
To: Greg KH <gregkh@linuxfoundation.org>, Sasha Levin <sashal@kernel.org>
Cc: Miklos Szeredi <mszeredi@redhat.com>, stable <stable@vger.kernel.org>, overlayfs <linux-unionfs@vger.kernel.org>
List-Id: linux-unionfs@vger.kernel.org

On Sun, Jun 9, 2019 at 12:45 PM <gregkh@linuxfoundation.org> wrote:
>
>
> The patch below does not apply to the 5.1-stable tree.
> If someone wants it applied there, or to any other stable or longterm
> tree, then please email the backport, including the original git commit
> id to <stable@vger.kernel.org>.
>
> thanks,
>
> greg k-h
>

FYI, the failure to apply this patch would be resolved after you
picked up "ovl: check the capability before cred overridden" for
stable, please hold off from taking this patch just yet, because
it has a bug, whose fix wasn't picked upstream yet.

Thanks,
Amir.
