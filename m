From: Miklos Szeredi <miklos@szeredi.hu>
Subject: Re: [PATCH] ovl: Fix info leak in ovl_lookup_temp()
Date: Wed, 21 Sep 2016 16:38:55 +0200
Message-ID: <CAJfpegte3dZKjjLx=to+2XSYyXDkAuuAfhBLHJmuxssuYAGYHg@mail.gmail.com>
References: <1474019124-11340-1-git-send-email-richard@nod.at> <CAGXu5j+9ozB07MMtwZjL6ATtSFyvawX0pM4K0S4h1A6L8+uarA@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <CAGXu5j+9ozB07MMtwZjL6ATtSFyvawX0pM4K0S4h1A6L8+uarA@mail.gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
To: Kees Cook <keescook@chromium.org>
Cc: Richard Weinberger <richard@nod.at>, "linux-unionfs@vger.kernel.org" <linux-unionfs@vger.kernel.org>, LKML <linux-kernel@vger.kernel.org>
List-Id: linux-unionfs@vger.kernel.org

On Fri, Sep 16, 2016 at 10:36 PM, Kees Cook <keescook@chromium.org> wrote:
> On Fri, Sep 16, 2016 at 2:45 AM, Richard Weinberger <richard@nod.at> wrote:
>> The function uses the memory address of a struct dentry as unique id.
>> While the address-based directory entry is only visible to root
>> it is IMHO still worth fixing since the temporary name does not have
>> to be a kernel address. It can be any unique number. Replace it by an
>> atomic integer which is allowed to wrap around.
>>
>> Signed-off-by: Richard Weinberger <richard@nod.at>

Thanks, applied and pushed to #overlayfs-next.

Thanks,
Miklos
