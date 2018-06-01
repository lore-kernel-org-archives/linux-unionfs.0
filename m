From: Miklos Szeredi <miklos@szeredi.hu>
Subject: Re: [GIT PULL] overlayfs update for 4.18
Date: Fri, 1 Jun 2018 19:03:36 +0200
Message-ID: <CAJfpegvON3nNumNhSbG2nozkMPuPGNX4m3HPpk6Cdj0skYna4g@mail.gmail.com>
References: <20180529132148.GC23785@veci.piliscsaba.redhat.com>
 <20180601152625.GD23785@veci.piliscsaba.redhat.com> <1d1b5ffb-4786-6b7a-fbf3-84b79080ccff@infradead.org>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <1d1b5ffb-4786-6b7a-fbf3-84b79080ccff@infradead.org>
Sender: linux-kernel-owner@vger.kernel.org
To: Randy Dunlap <rdunlap@infradead.org>
Cc: Al Viro <viro@zeniv.linux.org.uk>, linux-kernel@vger.kernel.org, linux-fsdevel@vger.kernel.org, overlayfs <linux-unionfs@vger.kernel.org>
List-Id: linux-unionfs@vger.kernel.org

On Fri, Jun 1, 2018 at 6:18 PM, Randy Dunlap <rdunlap@infradead.org> wrote:
> On 06/01/2018 08:26 AM, Miklos Szeredi wrote:
>> On Tue, May 29, 2018 at 03:21:48PM +0200, Miklos Szeredi wrote:
>>> Hi Al,
>>>
>>> I'm sending this pull request to you instead of Linus, because a bigger than
>>> usual chunk involves the VFS.
>>>
>>> Please pull from:
>>>
>>>   git://git.kernel.org/pub/scm/linux/kernel/git/mszeredi/vfs.git for-viro
>>>
>>> This update contains the following:
>
>
>> ---
>>
>> diff --git a/Documentation/filesystems/overlayfs.txt b/Documentation/filesystems/overlayfs.txt
>> index 0a8e3c4543d1..79be4a77ca08 100644
>> --- a/Documentation/filesystems/overlayfs.txt
>> +++ b/Documentation/filesystems/overlayfs.txt
>> @@ -280,7 +280,7 @@ parameter metacopy=on/off. Lastly, there is also a per mount option
>>  metacopy=on/off to enable/disable this feature per mount.
>>
>>  Do not use metacopy=on with untrusted upper/lower directories. Otherwise
>> -it is possible that an attacker can create a handcrafted file with
>> +it is possible that an attacker can create an handcrafted file with
>
> bad change:
>                                        create a handcrafted
>
> Wait. Is this patch -R (reversed)?

Oops, yes, reversed diff.

Thanks,
Miklos
