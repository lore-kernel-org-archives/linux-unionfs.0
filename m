Return-Path: <amir73il@gmail.com>
MIME-Version: 1.0
In-Reply-To: <CAJfpegvyjQrJ8MMXHSGx8sDoeMM2P1DvEHZtARp+Vu4bSetzJQ@mail.gmail.com>
References: <1520547490-25194-1-git-send-email-amir73il@gmail.com> <CAJfpegvyjQrJ8MMXHSGx8sDoeMM2P1DvEHZtARp+Vu4bSetzJQ@mail.gmail.com>
From: Amir Goldstein <amir73il@gmail.com>
Date: Thu, 29 Mar 2018 14:04:40 +0300
Message-ID: <CAOQ4uxid8+B5SowifN3NuKtF-93QvbHoqj=vv+8viMNTV9nkXQ@mail.gmail.com>
Subject: Re: [RFC][PATCH] ovl: opaque xattr should overrule redirect xattr
Content-Type: text/plain; charset="UTF-8"
To: Miklos Szeredi <miklos@szeredi.hu>
Cc: Vivek Goyal <vgoyal@redhat.com>, overlayfs <linux-unionfs@vger.kernel.org>
List-ID: <linux-unionfs@vger.kernel.org>

On Thu, Mar 29, 2018 at 1:19 PM, Miklos Szeredi <miklos@szeredi.hu> wrote:
> On Thu, Mar 8, 2018 at 11:18 PM, Amir Goldstein <amir73il@gmail.com> wrote:
>> opaque xattr and redirect xattr are not expected to be both set on the
>> same directory, but in case they do, the opaque directive to stop
>> merging lower dirs should overrule an absolute redirect directive to
>> escape a pure directory.
>>
>> This change comes with a cost of removing the optimiaztion for not
>> checking opaque xattr on lookup in last parent layer.
>> Instead, it adds an optimization for not checking opaque nor redirect
>> xattr on lookup in overlay instance lowermost layer.
>
> AFAICS this one's obsoleted by Vivek's "ovl: Set d->last properly
> during lookup", so using that one.
>


Correct.
Thanks,
Amir.
