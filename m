From: Miklos Szeredi <mszeredi@redhat.com>
Subject: Re: [PATCH v2 22/35] vfs: don't open real
Date: Mon, 7 May 2018 12:29:37 +0200
Message-ID: <CAOssrKdYcqQTnYjWFhF1hJOBDqu7NwZhGvxbQA=ZbLoFYw9SKA@mail.gmail.com>
References: <20180507083807.28792-1-mszeredi@redhat.com> <20180507083807.28792-23-mszeredi@redhat.com>
 <CAOQ4uxi-_0xkSgHnzBhJLnWTyz_m0VXTx9206k2vZA6dgtQYmQ@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <CAOQ4uxi-_0xkSgHnzBhJLnWTyz_m0VXTx9206k2vZA6dgtQYmQ@mail.gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
To: Amir Goldstein <amir73il@gmail.com>
Cc: overlayfs <linux-unionfs@vger.kernel.org>, linux-fsdevel <linux-fsdevel@vger.kernel.org>, linux-kernel <linux-kernel@vger.kernel.org>, Al Viro <viro@zeniv.linux.org.uk>
List-Id: linux-unionfs@vger.kernel.org

On Mon, May 7, 2018 at 12:27 PM, Amir Goldstein <amir73il@gmail.com> wrote:
> On Mon, May 7, 2018 at 11:37 AM, Miklos Szeredi <mszeredi@redhat.com> wrote:
>> Let overlayfs do its thing when opening a file.
>>
>> This enables stacking and fixes the corner case when a file is opened for
>> read, modified through a writable open, and data is read from the read-only
>> file.  After this patch the read-only open will not return stale data even
>> in this case.
>>
>
> So now you can get rid of ovl_do_check_copy_up() and the check_copy_up
> module param ;-)

Ah, forgot about that one.   Indeed.

Thanks,
Miklos
