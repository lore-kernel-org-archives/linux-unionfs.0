From: Miklos Szeredi <miklos@szeredi.hu>
Subject: Re: [PATCH 03/28] ovl: Provide a mount option metacopy=on/off for
 metadata copyup
Date: Wed, 30 May 2018 10:27:18 +0200
Message-ID: <CAJfpegtSm8_xHspGtuP5b+4uasG4jU-apAmsjtJ-fVeL8uhZNg@mail.gmail.com>
References: <20180529144612.16675-1-mszeredi@redhat.com> <20180529144612.16675-4-mszeredi@redhat.com>
 <d5621dfa-46f6-4b5a-4d69-6c6fb9370cfe@infradead.org>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <d5621dfa-46f6-4b5a-4d69-6c6fb9370cfe@infradead.org>
Sender: linux-kernel-owner@vger.kernel.org
To: Randy Dunlap <rdunlap@infradead.org>
Cc: Miklos Szeredi <mszeredi@redhat.com>, overlayfs <linux-unionfs@vger.kernel.org>, linux-fsdevel@vger.kernel.org, linux-kernel@vger.kernel.org
List-Id: linux-unionfs@vger.kernel.org

On Tue, May 29, 2018 at 10:44 PM, Randy Dunlap <rdunlap@infradead.org> wrote:
> On 05/29/2018 07:45 AM, Miklos Szeredi wrote:

>> +       If this config option is enabled then overlay filesystems will
>> +       copy up only metadata where appropriate and data copy up will
>> +       happen when a file is opended for WRITE operation. It is still
>
>                                 opened

Thanks for the feedback.  Fixed.

Miklos
