MIME-Version: 1.0
In-Reply-To: <CAOQ4uxhRuU5okDMCLxE4kxB0zTQfY_K9_DCvOnAVXm676yE_Jg@mail.gmail.com>
References: <1523623156-6035-1-git-send-email-cgxu519@gmx.com>
	<CAOQ4uxhRuU5okDMCLxE4kxB0zTQfY_K9_DCvOnAVXm676yE_Jg@mail.gmail.com>
Date: Fri, 13 Apr 2018 15:46:20 +0200
Message-ID: <CAJfpegvXh0CQu-YrfcOqHP7W7geRzVokTanA0Dgm-qi2vm1=qQ@mail.gmail.com>
Subject: Re: [PATCH v4 0/3] option validation in remount
From: Miklos Szeredi <miklos@szeredi.hu>
Content-Type: text/plain; charset="UTF-8"
To: Amir Goldstein <amir73il@gmail.com>
Cc: Chengguang Xu <cgxu519@gmx.com>, overlayfs <linux-unionfs@vger.kernel.org>
List-ID: <linux-unionfs@vger.kernel.org>

On Fri, Apr 13, 2018 at 2:56 PM, Amir Goldstein <amir73il@gmail.com> wrote:
> On Fri, Apr 13, 2018 at 3:39 PM, Chengguang Xu <cgxu519@gmx.com> wrote:
>> Some overlayfs mount options cannot be changed via remount,
>> but current remount does not return error even if we specify
>> different value to unchangeable options.
>>
>> This patch series adjust option parsing to support remount
>> and return proper error message and code when recogonizing
>> unchangeable options in remount.
>>
>
> Surely, you have motivation beyond what is listed here.
> Would be nice to list short and long term goals for changing
> remount options.
>
> The series looks ok to me.
> There is a question whether erroring on remount with changed
> options is considered a regression to some applications.

Theoretically: yes.  In real life: maybe.  We need to be careful.

> I don't know how to answer that.
> Does your use case *require* that remount will fail?
> Would it be ok to ignore unchangeable options like today,
> but warn about it?

Adding a warning is definitely okay, since it makes no sense to supply
unchangeable options.  Maybe at some point we can change the warning
to a failure.

It would have been best to error out on unknown/unchangeable options
from the start.  Hopefully the new mount API will make implementing
option parsing and reconfiguration less error prone.

Thanks,
Miklos
