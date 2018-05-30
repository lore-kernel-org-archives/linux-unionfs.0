From: Miklos Szeredi <miklos@szeredi.hu>
Subject: Re: [PATCH 27/39] ovl: obsolete "check_copy_up" module option
Date: Wed, 30 May 2018 10:26:12 +0200
Message-ID: <CAJfpegsK2y3M1zY9FPDM1EZ1fmkoWmTYQx=heQdhx6eqH7881A@mail.gmail.com>
References: <20180529144339.16538-1-mszeredi@redhat.com> <20180529144339.16538-28-mszeredi@redhat.com>
 <CAOQ4uxgbj0x+zMn47PiF819+kFE9Byos-KVGiGp7Mp=Gc0N8Wg@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <CAOQ4uxgbj0x+zMn47PiF819+kFE9Byos-KVGiGp7Mp=Gc0N8Wg@mail.gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
To: Amir Goldstein <amir73il@gmail.com>
Cc: Miklos Szeredi <mszeredi@redhat.com>, overlayfs <linux-unionfs@vger.kernel.org>, linux-fsdevel <linux-fsdevel@vger.kernel.org>, linux-kernel <linux-kernel@vger.kernel.org>
List-Id: linux-unionfs@vger.kernel.org

On Tue, May 29, 2018 at 5:13 PM, Amir Goldstein <amir73il@gmail.com> wrote:
> On Tue, May 29, 2018 at 5:43 PM, Miklos Szeredi <mszeredi@redhat.com> wrote:

>> +       WARN(1, "overlayfs: \"check_copy_up\" module option is obsolete\n");
>
> I was under the impression that user controlled input should not be generating
> WARNings... did you mean pr_warm?

Okay.

Thanks,
Miklos
