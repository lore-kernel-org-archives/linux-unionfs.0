From: Stephen Smalley <sds@tycho.nsa.gov>
Subject: Re: overlayfs access checks on underlying layers
Date: Tue, 4 Dec 2018 11:49:16 -0500
Message-ID: <e8841bf0-d6b8-0e7d-6a35-055a06441d30@tycho.nsa.gov>
References: <CAJfpegv6y56k1-Tewu-Pu3x1W75LL6qYB6Hb6=n+2BJoNfEigA@mail.gmail.com>
 <c993dba4-5129-7f04-2724-a82a1f1cafa3@tycho.nsa.gov>
 <f84bbe0b-f4c1-50e0-8c84-a6589154b3ae@tycho.nsa.gov>
 <CAJfpegtBDTMbmKd6eDxRmtSJjGN6CnpGK_QPNSsxjkOoeu=1pQ@mail.gmail.com>
 <4c20a261-5ce1-f0a2-8d40-c6032a023216@tycho.nsa.gov>
 <20181204151549.GA21509@redhat.com> <20181204152248.GB21509@redhat.com>
 <CAJfpegtFVvq286HAorGLg6ywMsfs51KqaQwFkcuV7Dtu8TLaLg@mail.gmail.com>
 <20181204154243.GA16818@redhat.com>
 <665ec6f3-f16d-681f-30d5-eface14c9808@tycho.nsa.gov>
 <20181204161747.GC16818@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <20181204161747.GC16818@redhat.com>
Content-Language: en-US
Sender: linux-kernel-owner@vger.kernel.org
To: Vivek Goyal <vgoyal@redhat.com>
Cc: Miklos Szeredi <miklos@szeredi.hu>, Ondrej Mosnacek <omosnace@redhat.com>, "J. Bruce Fields" <bfields@fieldses.org>, Mark Salyzyn <salyzyn@android.com>, Paul Moore <paul@paul-moore.com>, linux-kernel@vger.kernel.org, overlayfs <linux-unionfs@vger.kernel.org>, linux-fsdevel@vger.kernel.org, selinux@vger.kernel.org, Daniel J Walsh <dwalsh@redhat.com>
List-Id: linux-unionfs@vger.kernel.org

On 12/4/18 11:17 AM, Vivek Goyal wrote:
> On Tue, Dec 04, 2018 at 11:05:46AM -0500, Stephen Smalley wrote:
>> On 12/4/18 10:42 AM, Vivek Goyal wrote:
>>> On Tue, Dec 04, 2018 at 04:31:09PM +0100, Miklos Szeredi wrote:
>>>> On Tue, Dec 4, 2018 at 4:22 PM Vivek Goyal <vgoyal@redhat.com> wrote:
>>>>
>>>>> Having said that, this still create little anomaly when mknod to client
>>>>> is not allowed on context label. So a device file, which is on lower
>>>>> and client can not open it for read/write on host, it can now be opened
>>>>> for read/write because mounter will allow access. So why it is different
>>>>> that regular copy up. Well, in regular copy up, we created a copy of
>>>>> the original object and allowed writing to that object (cp --preserve=all)
>>>>> model. But in case of device file, writes will go to same original
>>>>> object. (And not a separate copy).
>>>>
>>>> That's true.
>>>>
>>>> In that sense copy up of special file should result in upper having
>>>> the same label as of lower, right?
>>>
>>> I guess that might be reasonable (if this behavior is a concern). So even
>>> after copy up, client will not be able to read/write a device if it was
>>> not allowed on lower.
>>>
>>> Stephen, what do you think about retaining label of lower for device
>>> files during copy up. What about socket/fifo.
>>
>> We don't check client task access to the upper inode label, only to the
>> overlay, right?  So the client is still free to access the device through
>> the overlay even if we preserve the lower inode label on the upper inode?
>> What do we gain?
> 
> That's only with latest code and Miklos said he will revert it for 4.20.
> 
> IOW, I am assuming that we will continue to check access to a file
> on upper in the context of mounter. Otherwise, client will be able to access
> files on upper/ which even mounter can't access.

I was assuming we're talking about the proposed solution, where we check 
client access to the overlay (unchanged), mounter access to lower 
(unchanged), copy-up if denied (new), mounter access to upper (new in 
the sense that previously we didn't copy-up on denials).

In that situation, propagating the lower inode label to the upper inode 
only impacts the mounter checks, and in that case makes copy-up 
pointless - if it wasn't allowed to lower it won't be allowed to upper. 
  If it is allowed, then client task is free to access the device 
regardless as long as it has permissions to the overlay inode.  So I 
don't see what we gain by propagating the lower inode label to the upper 
inode in the context mount case, and it creates an inconsistency between 
special files and regular ones.

Did I miss something?
